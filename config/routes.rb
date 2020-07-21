Rails.application.routes.draw do
  devise_for :users
  root 'projects#index'
  resources :projects do
    resources :tasks do
      member do
        patch 'done'
        patch 'move'
      end
    end
  end
end
