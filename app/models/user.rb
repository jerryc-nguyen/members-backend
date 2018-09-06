class User < ApplicationRecord
  include Serializeable

  has_many :posts
  has_many :oauths, dependent: :destroy

  DEFAULT_SERIALIZER = ActorSerializer

  validates :name, :email, presence: true


  def oauth_facebook
    @oauth_facebook ||= oauths.find_by_provider("facebook")
  end

  def oauth_google
    @oauth_google ||= oauths.find_by_provider("google_oauth2")
  end

  def auth_facebook?
    oauth_facebook.present?
  end

  def auth_google?
    oauth_google.present?
  end

  after_create do
    self.token = Auth::Jwt.generate_token_for(self)
    self.save(validate: false)
  end

end
