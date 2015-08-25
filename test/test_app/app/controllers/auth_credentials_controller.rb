class AuthCredentialsController < Croesus::AuthCredentialsController
  def determine_scopes
    [:user, :admin, :editor]
  end
end