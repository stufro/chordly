Rails.application.routes.draw do
  devise_for :users

  devise_scope :user do
    authenticated :user do
      root "home#index", as: :authenticated_root
    end

    unauthenticated do
      root "home#index", as: :unauthenticated_root
    end
  end

  resources :chord_sheets, only: %i[index new create show update destroy] do
    put :transpose, on: :member
  end

  resources :set_lists, only: %i[new create show update destroy] do
    put :add_chord_sheet, on: :member
    put :remove_chord_sheet, on: :member
    patch :reorder, on: :member
  end

  resource :trial, only: %i[new]

  resource :home, only: %i[index], controller: "home" do
    get :roadmap
    get :about
    get :privacy
    get :features
  end

  get "/admin", to: "admin#index"

  constraints FlipperUIAccess do
    mount Flipper::UI.app(Flipper) => "/flipper"
  end

  if Rails.env.development?
    namespace :dev do
      post "/change_user", to: "change_user#index"
    end
  end
end
