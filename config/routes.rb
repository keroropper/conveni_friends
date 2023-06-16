Rails.application.routes.draw do
  devise_for :users, controllers: { confirmations: 'confirmations', registrations: 'registrations' }
  devise_scope :user do
    get '/users/confirmation/info' => 'confirmations#info'
  end
  authenticated do
    root to: "secrets#index", as: :authenticated_root
  end
  root to: "home#index"
end
