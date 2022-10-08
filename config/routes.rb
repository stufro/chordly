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

  resources :chord_sheets, only: %i[index new create show update] do
    put :transpose, on: :member
  end

  resource :trial, only: %i[new]

  resource :home, only: %i[index], controller: "home" do
    get :roadmap
  end

  if Rails.env.development?
    namespace :dev do
      post "/change_user", to: "change_user#index"
    end
  end
end
