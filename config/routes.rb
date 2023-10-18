Rails.application.routes.draw do
  authenticated do
    root to: "secrets#index", as: :authenticated_root
    get 'secrets/search' => 'secrets#search'
  end
  root to: "home#index"

  resources :recruits, except: :index do
    resources :comments, only: [:create]
    resources :favorites, only: [:create, :destroy]
    resources :applicants, only: [:create, :destroy]
    get 'applicants/index' => 'applicants#recruit_applicants_index'
    collection do
      get 'search', to: 'recruits#search'
    end
  end
  get 'recruit_tags/create'
  get 'recruit_tags/destroy'

  devise_for :users, controllers: { confirmations: 'users/confirmations', registrations: 'users/registrations', passwords: 'users/passwords' }
  devise_scope :user do
    get '/users/confirmation/info' => 'users/confirmations#info'
    post '/users/guest_sign_in' => 'users/sessions#guest_sign_in'
  end
  resources :users, only: [:show, :edit, :update] do
    get 'applicants/index' => 'applicants#user_applicants_index'
    resources :relations, only: [:index, :create, :destroy]
    resources :notifications, only: [:index]
    resources :evaluations, only: [:index, :new, :create]
    get '/incomplete_evaluations', to: 'evaluations#incomplete_index'
    get '/recruits', to: 'users#recruit_index'
    get '/favorites', to: 'users#favorite_index'
    get '/my_page', to: 'users#my_page'
  end

  resources :chat_rooms, only: [:create, :destroy] do
    resources :chat_messages, only: :create
  end

  mount ActionCable.server => '/cable'
end
