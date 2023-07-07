Rails.application.routes.draw do
  get 'recruit_tags/create'
  get 'recruit_tags/destroy'
  devise_for :users, controllers: { confirmations: 'users/confirmations', registrations: 'users/registrations', passwords: 'users/passwords' }
  devise_scope :user do
    get '/users/confirmation/info' => 'users/confirmations#info'
  end
  authenticated do
    root to: "secrets#index", as: :authenticated_root
  end
  root to: "home#index"
  resources :recruits
  resources :users, only: [:show]
end
