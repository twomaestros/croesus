class AuthCredential < ActiveRecord::Base
  belongs_to :authenticatable, polymorphic: true
  
  scope :active, -> { where("expires_at > ?", Time.now.to_i) }
end
