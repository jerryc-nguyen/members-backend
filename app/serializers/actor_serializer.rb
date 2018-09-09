class ActorSerializer < ActiveModel::Serializer
  attributes  :id, :name, :email, :formatted_address, :avatar_url, :company_name, :company_avatar_url, :job_title

  def avatar_url
    'https://placeimg.com/100/100/animals'
  end

  def company_avatar_url
    'https://placeimg.com/100/100/nature'
  end

  def company_name
    Faker::Name.unique.name
  end

  def formatted_address
    Faker::Address.street_address
  end

  def job_title
    Faker::Job.title
  end
end

