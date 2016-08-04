Rails.application.routes.draw do

  devise_for :volunteers, :path => '', :controllers => {:registrations => "registrations"}

  resources :voters, only: [:new, :create]
  resources :organizations, only: [:index, :new, :create, :destroy]

  get '/voters/:hashed_id', to: 'voters#voter_home', as: 'voter_home'

  root :to => 'voters#new'
  
end
