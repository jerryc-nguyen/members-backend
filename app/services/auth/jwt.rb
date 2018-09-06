class Auth::Jwt
  attr_reader :token

  def initialize(token)
    @token = token
  end

  def self.generate_token_for(user)
    raise "User id is required." if user.id.blank?
    payload = { user_id: user.id, last_token_generation_time: Time.now.to_i }
    JWT.encode(payload, hmac_secret, algorithm)
  end

  def valid?
    begin
      user.present?
    rescue => e
      false
    end
  end

  def expired?
    (Time.now.to_i - last_token_generation_time) > Auth::Jwt.expired_time
  end

  def last_token_generation_time
    payload["last_token_generation_time"].to_i
  end

  def user
    @user ||= User.find_by_id(payload["user_id"])
  end

  private

  def payload
    @payload ||= JWT.decode(token, Auth::Jwt.hmac_secret, true, { :algorithm => Auth::Jwt.algorithm }).first
  end

  def self.hmac_secret
    Settings.jwt.hmac_secret
  end

  def self.algorithm
    Settings.jwt.algorithm
  end

  def self.expired_time
    Settings.jwt.expired_time
  end

end

