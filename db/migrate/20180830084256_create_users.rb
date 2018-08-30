class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :job_title
      t.string :email
      t.string :avatar_url
      t.string :token
      t.string :formatted_address
      t.float :latitude
      t.float :longitude
      t.timestamps
    end
  end
end
