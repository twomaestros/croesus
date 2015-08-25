class FacebookCredential < ActiveRecord::Base
  belongs_to :authenticatable, polymorphic: true
end
