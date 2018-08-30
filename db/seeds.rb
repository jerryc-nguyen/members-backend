# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.destroy_all

10.times do
  u = User.create({
    name: Faker::Name.unique.name,
    email: Faker::Internet.email,
    job_title: Faker::Job.title,
    formatted_address: Faker::Address.street_address,
    latitude: Faker::Address.latitude,
    longitude: Faker::Address.longitude
  })

  if u.valid?
    p "Created #{u.id}"
  else
    p u.errors.full_messages.to_sentence
  end

end

Post.destroy_all

10.times do
  u = Post.create({
    title: Faker::Movie.quote,
    content: Faker::Lorem.paragraphs.join(" "),
    user_id: User.pluck(:id).sample
  })

  if u.valid?
    p "Created post #{u.id}"
  else
    p u.errors.full_messages.to_sentence
  end
end
