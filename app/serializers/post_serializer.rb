class PostSerializer < ActiveModel::Serializer
  attributes :id, :title, :content, :thumb_url, :user, :content_excerpt

  def user
    object.user.serialize
  end

  def thumb_url
    types = ['nature', 'animal', 'people', 'tech']
    "https://placeimg.com/320/200/#{types.sample}"
  end

  def content_excerpt
    object.content.truncate(80)
  end
end

