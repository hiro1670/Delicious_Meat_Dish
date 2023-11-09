Rails.application.routes.draw do
  namespace :admin do
    get 'homes/top'
    get 'homes/about'
    resources :users, only: [:index, :show, :edit, :update]
  end
  #管理者用
  devise_for :admin, skip: [:registrations, :password], controllers: {
    sessions: "admin/sessions"
  }

  #顧客用
  devise_for :users,skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions'
  }


  #顧客側のルーティング
  scope module: :public do
    root to: 'homes#top'
    get "about" => "homes#about", as: "about"
    get "tag/search" => "tagsearches#search"
    get "search" => "searches#search"
    resources :recipes, only: [:new, :create, :index, :show, :edit, :update, :destroy] do
      resource :favorite, only: [:create, :destroy]
      resources :recipe_comments, only: [:create, :destroy]
    end
    resources :users, only: [:show, :edit, :update] do
      collection do
        get "confirm"
        patch "withdraw"
      end
      member do
        get 'favorites'
      end
    end
  end

  devise_scope :user do
    post 'users/guest_sign_in', to: 'users/sessions#guest_sign_in'
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end