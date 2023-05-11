# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }

  root to: 'home#index'

  resources :categories
  resources :products

  controller :products do
    delete :remove_picture
  end


  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
