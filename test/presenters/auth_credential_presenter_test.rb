require 'test_helper'

class AuthCredentialPresenterTest < ActiveSupport::TestCase
  test 'presents a JWT token' do
    expires_at = Time.now + 10.days
    auth_credential = AuthCredential.new(
      expires_at: expires_at,
      authenticatable_type: 'User',
      authenticatable_id: 123,
      secret: SecureRandom.hex(15),
      nonce: SecureRandom.hex(15),
      scopes: [:user, :test]
    )
    presented = Croesus::Presenters::AuthCredentialPresenter.new auth_credential
    payload = JWT.decode presented.token, auth_credential.secret
    
    assert payload['exp'] == expires_at.to_i
    assert payload['iat'] == Time.now.to_i
    assert payload['iss'] == Croesus.config.issuer
  end
end