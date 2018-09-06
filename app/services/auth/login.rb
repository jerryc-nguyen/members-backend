class Auth::Login

  attr_reader :user, :message, :params

  def initialize(params)
    @params = params
  end

  def login?
    begin

      case params[:provider]
      when "facebook"
        oauth_params = fetch_fb_oauth_params
        @user = find_or_create_user_from(oauth_params)
      else
        raise "Not implemented!"
      end

      unless @user.valid?
        @message = @user.errors.full_messages.to_sentence
      end

      @user.valid?
    rescue => e
      @message = e.message
      false
    end
  end

  private

  def fetch_fb_oauth_params
    raise "Token is required." if params[:token].blank?

    begin
      graph = Koala::Facebook::API.new(params[:token])
      data = graph.get_object('me', fields: ['id', 'name', 'email', 'birthday', 'gender', 'last_name', 'first_name', 'picture']).symbolize_keys
      {
        token: params[:token],
        uid: data[:id],
        provider: "facebook",
        name: data[:name],
        email: data[:email],
        first_name: data[:first_name],
        last_name: data[:last_name],
        image: (data[:picture] || {}).fetch("data", {}).fetch("url", nil)
      }
    rescue => e
      puts e.message
      puts e.backtrace
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
