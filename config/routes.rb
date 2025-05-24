Rails.application.routes.draw do
  resources :story_notes
  resources :story_tasks do
    collection do
      get "kanban"
    end
    member do
      patch "to_to_do"
      patch "to_active"
      patch "to_blocked"
      patch "to_finished"
      get "edit_form"
    end
  end

  devise_for :users, path: "auth"
  resources :users do
    member do
      get "switch"
      get "profile"
      get "edit_profile"
      patch "update_profile"
    end
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
