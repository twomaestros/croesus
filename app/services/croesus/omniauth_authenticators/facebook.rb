module Croesus
  class OmniauthAuthenticators::Facebook
    def self.call(omniauth_hash, authenticatable_class)
      new(omniauth_hash, authenticatable_class).authenticate_authenticatable
    end

    def initialize(omniauth_hash, authenticatable_class)
      @attributes = {
        email: omniauth_hash[:info][:email],
        first_name: omniauth_hash[:info][:first_name],
        last_name: omniauth_hash[:info][:last_name]
      }
      @authenticatable_class = authenticatable_class
      @uid = omniauth_hash[:uid]
      @token = omniauth_hash[:credentials][:token]
      @expires_at = omniauth_hash[:credentials][:expires_at]
    end

    def authenticate_authenticatable
      find_or_initialize_facebook_credentials
      find_or_create_authenticatable
      update_facebook_credentials

      return authenticatable
    end

    private

    attr_reader :uid, :email, :first_name, :last_name, :token, :expires_at, :context, :attributes
    attr_accessor :credentials, :authenticatable, :authenticatable_class

    def find_or_initialize_facebook_credentials
      self.credentials = FacebookCredential.where(uid: uid).first_or_initialize
    end

    def find_or_create_authenticatable
      self.authenticatable = if authenticatable_class.where(id: credentials.authenticatable_id).empty?
        attrib_mappings = authenticatable_class.croesus_config.attributes || {}
        assignable_attribs = {}
        
        if attrib_mappings.is_a? Array
          arr = attrib_mappings
          attrib_mappings = {}
          
          arr.each do |attrib|
            attrib_mappings[attrib] = attrib
          end
        end
        
        attrib_mappings.each do |model_attrib, oa_attrib|
          assignable_attribs[model_attrib] = attributes[oa_attrib]
        end
        
        authenticatable_class.create(assignable_attribs)
      else
        authenticatable_class.find(credentials.authenticatable_id)
      end
    end

    def update_facebook_credentials
      credentials.update_attributes(
        uid: uid,
        token: token,
        expires_at: DateTime.strptime(expires_at.to_s,'%s'),
        authenticatable: authenticatable
      )
    end
  end
end
