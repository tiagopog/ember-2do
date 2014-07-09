Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resource :sessions, only: [:create]
      resource :users, only: [:create, ]
      resources :projects, except: [:new, :edit]
      resources :tasks, except: [:new, :edit]
    end
  end
end
