Rails.application.routes.draw do
  root "home#index"

  resources :chord_sheets, only: %i[index new create show update] do
    put :transpose
  end

  resource :home, only: %i[index]
end
