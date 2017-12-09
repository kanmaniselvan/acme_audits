Rails.application.routes.draw do
  root to: 'object_statuses#index'

  resources :object_statuses, only: [:index, :show] do
    post :upload_csv, on: :collection
  end

end
