module Croesus
  class AuthenticateWithOmniauth
    def self.call(params = {})
      new(params).authenticate_with_omniauth
    end

    def initialize(params)
      @provider = params[:provider]
      @omniauth_hash = params[:omniauth_hash]
      @scopes = params[:scopes]
      @authenticatable_class = params[:croesus_mapping].to
    end

    def authenticate_with_omniauth
      find_or_create_authenticatable
      create_auth_credential
    end

    private

    attr_reader :provider, :omniauth_hash, :authenticatable, :authenticatable_class, :scopes, :croesus_mapping

    def find_or_create_authenticatable
      @authenticatable = "Croesus::OmniauthAuthenticators::#{provider.to_s.camelize}".constantize.call(omniauth_hash, authenticatable_class)
    end

    def create_auth_credential
      if authenticatable && authenticatable.valid?
        AuthCredential.create(
          expires_at: 2.months.from_now,
          authenticatable: authenticatable,
          secret: SecureRandom.hex(30),
          nonce: SecureRandom.hex(15),
          scopes: scopes.join(' ')
        )
      end
    end
  end
end
