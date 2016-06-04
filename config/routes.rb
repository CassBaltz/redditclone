Rails.application.routes.draw do


  resources :users, only: [:create, :new, :edit, :update, :show]
  resource :session, only: [:create, :new, :destroy]
  resources :subs, except: :destroy
  resources :posts, except: :index

end
