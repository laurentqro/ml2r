Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "prospects#index"

  resources :people

  resources :companies do
    resources :company_relationships
  end

  resources :prospects, only: :index

  resources :clients, only: [ :index, :create, :show ] do
    resources :company_relationships, only: [ :index, :new, :create, :edit, :update, :destroy ]
    resources :risk_assessments, except: [ :index ] do
      patch :approve, on: :member
    end

    member do
      patch :update_notes
      get :edit_notes
    end
  end

  resources :screenings, only: [ :create, :show ] do
    resources :matches, only: [ :index, :show ]
  end

  resources :adverse_media_checks, only: :create

  namespace :admin do
    resources :risk_factor_definitions
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  get "dashboard" => "pages#dashboard"

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
end
