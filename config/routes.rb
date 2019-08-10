Rails.application.routes.draw do
  get 'home/index'

  resources :lounges

  root 'home#index'
end
