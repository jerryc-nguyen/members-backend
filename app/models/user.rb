class User < ApplicationRecord
  include Serializeable

  has_many :posts

  DEFAULT_SERIALIZER = ActorSerializer

  validates :name, :email, presence: true
end
