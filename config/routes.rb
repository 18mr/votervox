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
  get '/volunteers/home', to: 'volunteers#home', as: 'volunteers_home'

  # Organization routes
  resources :organizations, only: [:index, :new, :create, :destroy]

  # Voter routes
  resources :voters, only: [:index, :new, :create] do
    member do
      get 'cancel'
      get 'activate'
    end
  end
  get '/voters/:hashed_id', to: 'voters#voter_home', as: 'voter_home'

  # Match routes
  resources :matches, only: [:index, :create, :show] do
    member do
      # Volunteer match routes
      post 'message'
      get 'decline'
      post 'complete'
      # Voter match routes
      get 'voter_accept'
      get 'voter_reject'
      post 'voter_request_time'
    end
  end

  # Document routes
  resources :documents, :path => 'voter-resources', only: [:index, :show, :new, :create, :update, :destroy]

  # Metrics routes
  resources :metrics, only: [:index]

  # Translation routes
  resources :locales do
    resources :translations, constraints: { :id => /[^\/]+/ }
  end

  # Application routes
  get '/', to: 'application#index', as: 'homepage'
  get '/feedback', to: 'application#feedback', as: 'feedback'
  post '/submit_feedback', to: 'application#submit_feedback', as: 'submit_feedback'
  get '/absentee-registration', to: 'application#absentee_registration', as: 'absentee_registration'
  get '/about', to: 'application#about', as: 'about'
  get '/privacy', to: 'application#privacy_policy', as: 'privacy_policy'
  get '/terms', to: 'application#terms_of_service', as: 'terms_of_service'

  root :to => 'application#index'
  
end
