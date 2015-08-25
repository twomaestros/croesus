Rails.application.routes.draw do
  croesus_for :monsters, skip: :all
  resources :users
  
  croesus_for :users, controllers: { auth_credentials: 'auth_credentials' }
end
