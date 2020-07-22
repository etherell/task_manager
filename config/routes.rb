Rails.application.routes.draw do
  devise_for :users
  root 'projects#index'
  resources :projects, except: %i[show new] do
    resources :tasks, except: %i[show index] do
      member do
        patch 'done'
        patch 'move'
      end
    end
  end
end
