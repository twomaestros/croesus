class CroesusCreateAuthCredentials < ActiveRecord::Migration
  def change
    create_table :auth_credentials do |t|
      t.datetime :expires_at, null: false
      t.string   :authenticatable_type, null: false
      t.integer  :authenticatable_id, null: false
      t.string   :secret, null: false, unique: true
      t.string   :nonce, null: false
      t.string   :scopes, null: false
    
      t.timestamps
    end
    
    add_index :auth_credentials,
              [:authenticatable_type, :authenticatable_id],
              unique: true,
              name: 'idx_auth_cred_on_auth_type_auth_id'
    add_index :auth_credentials,
              [:expires_at],
              name: 'idx_auth_cred_on_expires_at'
  end
end