class Post < ApplicationRecord
  include Serializeable

  belongs_to :user

  DEFAULT_SERIALIZER = PostSerializer

  validates :title, :content, :user, presence: true
end
