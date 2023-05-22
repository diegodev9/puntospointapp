# frozen_string_literal: true

Rails.application.routes.draw do

  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }

  namespace :api do
    namespace :v1 do
      devise_for :users, controllers: {
        sessions: 'api/v1/users/sessions'
      }
      get '/mas_comprados', to: 'api#mas_comprados'
      get '/mas_recaudado', to: 'api#mas_recaudado'
      get '/listar_compras', to: 'api#listar_compras'
      get '/cantidad_compras', to: 'api#cantidad_compras'
    end
  end

  root to: 'home#index'

  resources :categories
  resources :products
  scope :admin do
    resources :purchases, only: :index
  end

  resources :users, only: :purchases do
    member do
      get 'purchases'
    end
  end

  # namespace :api do
  # namespace :v1 do
  # end
  # end

  controller :products do
    delete :remove_picture
  end

  controller :purchases do
    post :buy_product
    get :congratulations
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
