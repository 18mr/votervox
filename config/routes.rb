Rails.application.routes.draw do

  resources :voters, only: [:new, :create]
  resources :organizations, only: [:index, :new, :create, :destroy]

  get '/voters/:hashed_id', to: 'voters#voter_home', as: 'voter_home'

  root :to => 'voters#new'
  
end
