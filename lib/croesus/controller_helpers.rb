module Croesus::ControllerHelpers
  def verify_auth_token
    begin
      target_user_id = (params['controller'] == 'api/v2/users/users' ? params['id'] : params['user_id'])
      data           = ActionController::HttpAuthentication::Token.token_and_options(request)
      token, nonce   = data[0], data[1]['nonce']
      # Extract user id without verification for now
      user_id        = JWT.decode(token, nil, false)[0]['user_id']
      credential     = AuthCredential.where(user_id: user_id, nonce: nonce).last
      # Decode token with verification now
      payload        = JWT.decode(token, credential.secret, true, verify_iat: true, leeway: 30)[0]
      scopes         = payload['scope'].split ','

      request['croesus.scopes'] = scopes

      auth_callback if self.respond_to? :auth_callback

      credential.update_attributes nonce: SecureRandom.hex(15)
      response.headers['Authorization'] = "Token nonce=\"#{credential.nonce}\""
    end
  end
end
