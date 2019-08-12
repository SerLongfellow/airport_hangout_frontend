Rails.application.routes.draw do
  get 'home/index'
  
  resources :sessions, only: [:new, :create]

  resources :lounges do
    resources :patrons, only: [:index, :create, :delete]
  end

  root 'home#index'
end
