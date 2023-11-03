Rails.application.routes.draw do
  #管理者用
  devise_for :admin, skip: [:registrations, :password], controllers: {
    sessions: "admin/sessions"
  }
  
  #顧客用
  devise_for :customers,skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions'
  }
  
  #顧客側のルーティング
  root to: 'homes#top'
  get "about" => "homes#about", as: "about"
  resources :recipes, only: [:new, :create, :index, :show, :edit, :update, :destroy]
  resources :customers, only: [:show, :edit, :update, :destroy] do
    collection do
      get "confirm"
      patch "withdraw"
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end