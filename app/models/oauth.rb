class Oauth < ApplicationRecord

  SUPPORTED_AUTH_SYSTEMS = ["facebook", "google_oauth2"]

  belongs_to :user

  validates :uid, presence: true
  validates :provider, presence: true
  validates :provider, inclusion: { in: SUPPORTED_AUTH_SYSTEMS }
  validates :oauth_name, presence: true

  def self.user_from_omniauth(auth)
    oauth = self.find_by(provider: auth.provider, uid: auth.uid)
    return oauth.user if oauth.present? && oauth.user.present?

    user = User.create(
      email: auth.info.email,
      name: auth.info.name,
      oauth_avatar: auth.info.image,
      uid: auth.uid
    )

    oauth = Oauth.new(
      provider: auth.provider,
      uid: auth.uid,
      email: auth.info.email,
      oauth_name: auth.info.name,
      oauth_avatar: auth.info.image,
      oauth_token: auth.credentials.token,
      oauth_refresh_token: auth.credentials.refresh_token,
      user_id: user.id
    )

    oauth.save(validate: false)
    user
  end


end
