Rails.application.routes.draw do
  get 'home/index'

  resources :lounges do
    resources :patrons
  end

  root 'home#index'
end
