Rails.application.routes.draw do
  get 'home/index'
  
  resources :sessions, only: [:new, :create]

  resources :airports, only: [:index] do
    resources :lounges, only: [:index]
  end

  resources :lounges, only: [:show] do
    resources :patrons, only: [:index, :create]
    delete 'patronage', :to => 'patrons#destroy'
  end
    
  resources :conversations, only: [:show, :create]

  root 'home#index'
end
