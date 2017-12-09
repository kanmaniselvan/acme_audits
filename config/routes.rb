Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  root to: 'object_statuses#index'

  resources :object_statuses, only: [:index] do
    collection do
      post :upload_csv
      get :get_object_changes
    end
  end

end
