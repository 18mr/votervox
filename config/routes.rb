Rails.application.routes.draw do

  devise_for :volunteers, :path => 'volunteer', :controllers => {:registrations => "registrations"}
  resources :volunteers, :only => [:index] do
    member do
      get 'approve'
      get 'ban'
      get 'make_admin'
    end
  end

  resources :voters, only: [:new, :create]
  resources :organizations, only: [:index, :new, :create, :destroy]

  get '/voters/:hashed_id', to: 'voters#voter_home', as: 'voter_home'

  root :to => 'voters#new'
  
end
