class ActorSerializer < ActiveModel::Serializer
  attributes  :id, :name, :formatted_address, :avatar_url, :company_name, :company_avatar

  def avatar_url
    'http://lorempixel.com/50/50/cats/'
  end

  def company_avatar
    'http://lorempixel.com/50/50/people/'
  end

  def company_name
    Faker::Name.unique.name
  end
end

