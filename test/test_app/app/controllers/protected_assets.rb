class ProtectedAssetsController < ApplicationController
  before_filter :verify_auth_token

  def index
  end

  def authorization_callback
  end
end
