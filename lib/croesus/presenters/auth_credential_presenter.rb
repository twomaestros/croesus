module Croesus
  module Presenters
    class AuthCredentialPresenter
      attr_reader :expires_at, :secret, :nonce, :scopes
      attr_reader :token, :public_key, :algorithm
    
      def initialize(credential)
        @expires_at = credential.expires_at.to_i
        @secret     = credential.secret
        @nonce      = credential.nonce
        @scopes     = credential.scopes
      end
    end
  end
end