Rails.application.routes.draw do
  get 'password_resets/new'
  get 'password_resets/edit'
  root 'home#top'
  devise_for :users do
    member do
      get :following, :followers
    end
  end
  resources :relationships,       only: [:create, :destroy]

  get 'search' => 'home#search'
  resources :messages
  resources :relationships, only: [:create, :destroy]
end
