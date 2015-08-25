class CroesusCreateFacebookCredentials < ActiveRecord::Migration
  def change
    create_table :facebook_credentials do |t|
      t.string   :authenticatable_type, null: false
      t.integer  :authenticatable_id, null: false
      t.string   :uid, null: false, unique: true
      t.string   :token, null: false, unique: true
      t.datetime :expires_at, null: false

      t.timestamps
    end
  end
end
