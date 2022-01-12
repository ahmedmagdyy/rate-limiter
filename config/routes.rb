Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "application#index"
  get '/track', to: 'application#track_rate_limit'
  get '/tracked', to: 'application#get_tracked_usage'

end
