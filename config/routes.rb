Rails.application.routes.draw do

  # devise_for :users
             # defaults: { format: :json }

  namespace :api, defaults: {format: 'json'} do
    controller :users do
      post    'users/create'  => :create
      patch   'users/update'  => :update
      delete  'users/delete' => :delete
    end

    controller :sessions do
      post   'sessions/login'  => :login
      delete 'sessions/logout' => :logout
    end

    controller :images do
      post   'images/new_image'  => :new_image
      post   'images/old_image'  => :old_image
      get    'images/index'  => :index
    end
  end

end
