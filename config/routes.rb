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
  resources :recruits, except: :index do
    resources :comments, only: [:create]
    resources :favorites, only: [:create, :destroy]
    resources :applicants, only: [:create, :destroy]
    get 'applicants/index' => 'applicants#recruit_applicants_index'
  end
  resources :users, only: [:show, :edit, :update] do
    get 'applicants/index' => 'applicants#user_applicants_index'
    resources :relations, only: [:index, :create, :destroy]
    member do
      get :following, :followers
    end
  end
  resources :chat_rooms, only: [:create, :destroy] do
    resources :chat_messages, only: :create
  end
  mount ActionCable.server => '/cable'
end
