Rails.application.routes.draw do
  resources :helps
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "chord_sheets#show"
  resources :chord_sheets, only: %i[show]
end
