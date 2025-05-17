Rails.application.routes.draw do
  devise_for :users, path: "auth"
  resources :users do
    collection do
      # get "/users/sign_in" => "devise/sessions#new"
      # post "/users/sign_in" => "devise/sessions#create"
      # delete "/users/sign_out" => "devise/sessions#destroy"
      # get "/users/password/new" => "devise/passwords#new"
      # get "/users/password/edit" => "devise/passwords#edit"
      # patch "/users/password" => "devise/passwords#update"
      # put "/users/password" => "devise/passwords#update"
      # post "/users/password" => "devise/passwords#create"
      # get "/users/cancel" => "devise/registrations#cancel"
      # get "/users/sign_up" => "devise/registrations#new"
      # get "/users/edit" => "devise/registrations#edit"
      # patch "/users" => "devise/registrations#update"
      # put "/users" => "devise/registrations#update"
      # delete "/users" => "devise/registrations#destroy"
      # post "/users" => "devise/registrations#create"
    end
    get "switch" => "users#switch", as: "switch"
  end
  resources :students
  get "/about" => "home#about"
  resources :people do
    collection do
      get "visual"
    end
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "home#index"
end
