require 'test_helper'
require 'omniauth_helpers'

class AuthenticateWithOmniauthTest < ActiveSupport::TestCase
  include Croesus::Test::OmniauthHelpers
  
  def authenticate_with_omniauth
    Croesus::AuthenticateWithOmniauth.call(
      scopes: [:new, :dance, :edit, :lol],
      provider: :facebook,
      omniauth_hash: omniauth_facebook_test_hash,
      croesus_mapping: Croesus.mappings.first
    )
  end
  
  def assert_attributes(model, attrs = {})
    attrs.each do |attrib, value|
      assert model.send(attrib) == value
    end
  end
  
  def assert_user_and_credentials_created
    assert User.all.count == 1
    assert AuthCredential.all.count == 1
    assert FacebookCredential.all.count == 1
  end
  
  def self.backup_user_model_settings
    @@croesus_config = User.croesus_config.dup
  end
  
  def self.restore_user_model_settings
    [:attributes].each do |setting|
      User.croesus_config.send("#{setting}=", @@croesus_config.send(setting))
    end
  end
  
  setup do
    DatabaseCleaner.start
  end
  
  teardown do
    DatabaseCleaner.clean
  end
  
  backup_user_model_settings
  
  MiniTest::Unit.after_tests do
    restore_user_model_settings
  end
  
  test 'creates a user' do
    User.croesus_config.attributes = nil
    authenticate_with_omniauth
    assert_user_and_credentials_created
    assert_attributes User.last, { email: nil, last_name: nil, first_name: nil, scopes: 'new dance edit lol' }
  end
  
  test 'array style attributes mapping' do
    User.croesus_config.attributes = [:email, :last_name]
    authenticate_with_omniauth
    assert_user_and_credentials_created
    assert_attributes User.last, { email: 'ersin@twomaestros.com', last_name: 'Akinci', first_name: nil, scopes: 'new dance edit lol' }
  end
  
  test 'hash style attributes mapping' do
    User.croesus_config.attributes = { email: :email, last_name: :first_name }
    authenticate_with_omniauth
    assert_user_and_credentials_created
    assert_attributes User.last, { email: 'ersin@twomaestros.com', last_name: 'Ersin', first_name: nil, scopes: 'new dance edit lol' }
  end
end