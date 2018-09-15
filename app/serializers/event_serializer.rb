class EventSerializer < ActiveModel::Serializer
  attributes :id, :title, :thumb_url, :users

  def users
    User.order("random()").limit(1).map{|u| u.serialize}
  end

  def thumb_url
    types = ['nature', 'animal', 'people', 'tech']
    "https://placeimg.com/320/200/#{types.sample}"
  end

  def content_excerpt
    object.content.truncate(80)
  end
end

