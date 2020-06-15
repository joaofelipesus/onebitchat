Rails.application.routes.draw do
  root to: 'teams#index'
  resources :teams, only: [:create, :destroy]
  resources :team_users, only: [:create, :destroy, :index]
  get '/:slug', to: 'teams#show'
  resources :channels, only: [:show, :create, :destroy]
  resources :talks, only: [:show]
  devise_for :users, :controllers => { registrations: 'registrations' }
  mount ActionCable.server => '/cable'
end
