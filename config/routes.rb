Rails.application.routes.draw do
  get 'home/index'

  resources :lounges do
    resources :patrons, only: [:index, :create, :delete]
  end

  root 'home#index'
end
