Rails.application.routes.draw do
  devise_for :users
  
  resources :users, only: %i[index] do
    collection do
      get :change_admin_rights
    end
  end

  root to: "home#index"
end
