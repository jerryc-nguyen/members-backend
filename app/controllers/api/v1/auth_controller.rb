class Api::V1::AuthController < ApiController
  skip_before_action :authenticate!

  def login
    validate_login_params!

    if login_system.login?
      response = login_system.user.serialize(UserAuthSerializer)
      success(data: response)
    else
      error(message: login_system.message)
    end
  end

  private

  def login_system
    @login_system ||= Auth::Login.new(login_params)
  end

  def login_params
    params.permit(
      :provider, :token
    )
  end

  def validate_login_params!
    raise "oauth_params must contain: provider, token" if (params.keys.map(&:to_sym) & [:provider, :token]).length != 2
  end

end
