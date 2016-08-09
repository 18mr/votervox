Rails.application.routes.draw do

  # Volunteer routes
  devise_for :volunteers, :path => 'volunteer', :controllers => {:registrations => "registrations"}
  resources :volunteers, :only => [:index] do
    member do
      get 'approve'
      get 'ban'
      get 'make_admin'
    end
  end

  # Organization routes
  resources :organizations, only: [:index, :new, :create, :destroy]

  # Voter routes
  resources :voters, only: [:index, :new, :create]
  get '/voters/:hashed_id', to: 'voters#voter_home', as: 'voter_home'
  get '/voters/:hashed_id/cancel', to: 'voters#cancel_request', as: 'voter_cancel_request'
  get '/voters/:hashed_id/activate', to: 'voters#activate_request', as: 'voter_activate_request'

  # Volunteer match routes
  resources :matches, only: [:index, :create, :show] do
    member do
      post 'message'
      get 'decline'
      post 'complete'
    end
  end

  # Voter match routes
  get 'matches/:id/show/:hashed_id', to: 'matches#voter_match', as: 'voter_match'
  get 'matches/:id/accept/:hashed_id', to: 'matches#accept', as: 'accept_match'
  get 'matches/:id/reject/:hashed_id', to: 'matches#reject', as: 'reject_match'
  post 'matches/:id/request_time/:hashed_id', to: 'matches#request_time', as: 'request_match_time'

  # Document routes
  resources :documents, only: [:index, :show, :new, :create, :update, :destroy]

  # Metrics routes
  resources :metrics, only: [:index]

  # Application routes
  get '/', to: 'application#index', as: 'homepage'
  get '/feedback', to: 'application#feedback', as: 'feedback'
  post '/submit_feedback', to: 'application#submit_feedback', as: 'submit_feedback'
  get '/about', to: 'application#about', as: 'about'
  get '/privacy', to: 'application#privacy_policy', as: 'privacy_policy'
  get '/terms', to: 'application#terms_of_service', as: 'terms_of_service'

  root :to => 'application#index'
  
end
