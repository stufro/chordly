Rails.application.routes.draw do
  devise_for :users

  devise_scope :user do
    authenticated :user do
      root "home#index", as: :authenticated_root

    end

    unauthenticated do
      root "devise/sessions#new", as: :unauthenticated_root
    end
  end

  resources :chord_sheets, only: %i[index new create show update] do
    put :transpose
  end

  resource :home, only: %i[index]
end
