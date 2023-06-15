Rails.application.routes.draw do
  get 'users/dummy'
  devise_for :users, controllers: { confirmations: 'confirmations', registrations: 'registrations' }
  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
    get '/users/confirmation/info' => 'confirmations#info'
  end
  get '/users' => 'users#dummy'
end
