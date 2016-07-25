Rails.application.routes.draw do

  resources :voters, only: [:new, :create]

  get '/voters/:hashed_id', to: 'voters#voter_home', as: 'voter_home'

  root :to => 'voters#new'
  
end
