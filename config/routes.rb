# frozen_string_literal: true

Rails.application.routes.draw do
  resources :helps
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  root "chord_sheets#index"
  resources :chord_sheets, only: %i[index new create show update] do
    put :transpose
  end
end
