Rails.application.routes.draw do
  get 'users/dummy'
  devise_for :users
  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end
  get '/users' => 'users#dummy'
end
