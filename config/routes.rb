WingifySample::Application.routes.draw do
  devise_for :users, :controllers => { :sessions => "api/v1/sessions" }

  devise_scope :user do
    namespace :api do
      namespace :v1 do
        resources :sessions, :only => [:create, :destroy]
      end
    end
  end
end
