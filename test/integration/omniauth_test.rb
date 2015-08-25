require 'test_helper'
require 'omniauth_helpers'

class OmniauthTest < ActionDispatch::IntegrationTest
  include Croesus::Test::OmniauthHelpers
  
  def auth_credential
    AuthCredential.last
  end
  
  setup do
    Rails.application.env_config['omniauth.hash'] = omniauth_facebook_test_hash
    
    DatabaseCleaner.start
    get '/users/auth/facebook/callback', nil, { accept: 'application/json' }
  end
  
  teardown do
    DatabaseCleaner.clean
  end
  
  test 'responds successfully' do
    assert_response :success
  end
  
  test 'creates a user' do
    assert User.all.count == 1
  end
  
  test 'responds with credential info' do
    public_key = OpenSSL::PKey::EC.new auth_credential.public_key
    payload    = JWT.decode json['token'], public_key
    
    assert payload[:scopes] == auth_credential.scopes
  end
end