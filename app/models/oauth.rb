class Oauth < ApplicationRecord

  SUPPORTED_AUTH_SYSTEMS = ["facebook", "google_oauth2"]

  belongs_to :user

  validates :uid, presence: true
  validates :provider, presence: true
  validates :provider, inclusion: { in: SUPPORTED_AUTH_SYSTEMS }
  validates :oauth_name, presence: true

end
