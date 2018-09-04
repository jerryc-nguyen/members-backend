class PostSerializer < ActiveModel::Serializer
  attributes :id, :title, :content, :thumb_url, :user

  def user
    object.user.serialize
  end

  def thumb_url
    "https://lorempixel.com/300/200/nature"
  end
end

