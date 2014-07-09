Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resource :sessions, only: [:create]
      resource :users, only: [:create, ]
      resources :projects, except: [:new, :edit] do
        get '/tasks/done::done' => 'tasks#index'
        patch '/tasks/:id/done' => 'tasks#done'
        resources :tasks, except: [:new, :edit]
      end
    end
  end
end
