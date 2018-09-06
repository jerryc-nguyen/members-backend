class CreateOauths < ActiveRecord::Migration[5.1]
  def change
    create_table :oauths do |t|
      t.string        :provider,                       default: "",    null: false
      t.string        :uid,                            default: "",    null: false
      t.string        :email,                          default: ""
      t.string        :oauth_avatar,                   default: ""
      t.string        :oauth_token,                    default: ""
      t.string        :oauth_name,                     default: "",    null: false
      t.string        :oauth_refresh_token
      t.string        :oauth_code
      t.references    :user, index: true
      t.timestamps
    end
  end
end
