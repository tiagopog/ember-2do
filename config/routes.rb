Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resource :users, only: [:create]
      resource :projects, except: [:new, :edit]
      resource :tasks, except: [:new, :edit]
    end
  end
end
