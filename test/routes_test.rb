require 'test_helper'

class RoutesTest < ActionController::TestCase
  test 'omniauth callback' do
    assert_routing('users/auth/facebook/callback', { controller: 'auth_credentials', action: 'create', provider: 'facebook' })
  end
end