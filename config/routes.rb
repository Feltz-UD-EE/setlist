Rails.application.routes.draw do

  # authentication and user status routes are automatically defined and are not configured here

  # public static & home routes
  root to: 'static#public_home'
  get 'public_home', to: 'static#public_home'
  get 'about', to: 'static#about'
  get 'credits', to: 'static#credits'
  get 'legal', to: 'static#legal'
  get 'lists/start', to: 'lists#start'
  post 'lists/play', to: 'lists#play'

  resources :bands
  resources :players
  resources :lists
  resources :songs

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
