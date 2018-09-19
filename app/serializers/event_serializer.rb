class EventSerializer < ActiveModel::Serializer
  attributes :id, :title, :thumb_url, :users, :company, :formatted_address, :start_date, :start_time

  def users
    User.order("random()").limit(5).map{|u| u.serialize}
  end

  def thumb_url
    types = ['nature', 'animal', 'people', 'tech']
    "https://placeimg.com/320/200/#{types.sample}"
  end

  def content_excerpt
    object.content.truncate(80)
  end

  def company
    {
      name: Faker::Name.unique.name,
      thumb_url:'https://placeimg.com/100/100/tech'
    }
  end

  def formatted_address
    Faker::Address.street_address
  end

  def start_date
    '25.09.2015'
  end

  def start_time
    '11:30am'
  end
end

