module Croesus
  class AuthCredentialsController < ApplicationController
    # Should never be called. Instead, OmniAuth should intercept requests
    # bound for this endpoint.
    def passthru
      head :not_found
    end

    def create
      credential = authenticate_from_omniauth(params[:provider])
      
      if credential
        respond_to do |format|
          format.json { render json: credential, status: :created }
        end
      else
        head :not_found
      end
    end

    private
    
      # Overridden in subclasses
      def determine_scopes
        raise
      end
      
      def authenticate_from_omniauth(provider)
        credential = AuthenticateWithOmniauth.call(
          scopes: determine_scopes,
          provider: provider,
          omniauth_hash: request.env['omniauth.hash'],
          croesus_mapping: request.env['croesus.mapping']
        )
      
        if credential
          Presenters::AuthCredentialPresenter.new(credential)
        else
          nil
        end
      end
  end
end
