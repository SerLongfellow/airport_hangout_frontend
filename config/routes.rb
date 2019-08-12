Rails.application.routes.draw do
  get 'home/index'
  
  resources :sessions, only: [:new, :create]

  resources :airports, only: [:index] do
    resources :lounges, only: [:index, :show] do
      resources :patrons, only: [:index, :create, :destroy]
    end
  end

  root 'home#index'
end
