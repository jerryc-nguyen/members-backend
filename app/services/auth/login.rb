class Auth::Login

  attr_reader :user, :message, :params

  def initialize(params)
    @params = params
    @provider = params[:provider]
    @uid = params[:uid]
  end

  def login?
    begin
      @user = find_or_create_user_from(params)

      unless @user.valid?
        @message = @user.errors.full_messages.to_sentence
      end

      @user.valid?
    rescue => e
      @message = e.message
      false
    end
  end

  def find_or_create_user_from(oauth_params)
    oauth = Oauth.find_by(provider: oauth_params[:provider], uid: oauth_params[:uid])
    return oauth.user if oauth.present? && oauth.user.present?

    user = User.create(
      email: oauth_params[:email],
      name: oauth_params[:name]
    )

    oauth = Oauth.new(
      provider: oauth_params[:provider],
      uid: oauth_params[:uid],
      email: oauth_params[:email],
      oauth_name: oauth_params[:name],
      oauth_avatar: oauth_params[:image],
      oauth_token: oauth_params[:token],
      oauth_refresh_token: oauth_params[:refresh_token],
      user_id: user.id
    )

    oauth.save(validate: false)
    user
  end
end
