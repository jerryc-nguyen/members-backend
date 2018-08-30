class ActorSerializer < ActiveModel::Serializer
  attributes  :id, :name, :formatted_address, :phone, :avatar_url

end

