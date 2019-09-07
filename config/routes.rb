Rails.application.routes.draw do
  get 'home/index'
  get 'health_check', to: 'health_check#status'
  
  resources :sessions, only: [:new, :create]

  resources :airports, only: [:index] do
    resources :lounges, only: [:index]
  end

  resources :lounges, only: [:show] do
    resources :patrons, only: [:index, :create]
    delete 'patronage', :to => 'patrons#destroy'
  end
    
  resources :conversations, only: [:index, :show, :create] do
    resources :messages, only: [:create]
  end

  root 'home#index'
end
