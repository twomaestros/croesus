Rails.application.routes.draw do
  resources :users
  
  croesus_for :users, controllers: { auth_credentials: 'auth_credentials' }
end
