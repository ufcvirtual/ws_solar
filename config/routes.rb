WsSolar::Application.routes.draw do

  devise_for :users, :controllers => { :sessions => "sessions" }

  devise_scope :user do
    get "logout", :to => "devise/sessions#destroy"
    resources :sessions, :only => [:create, :destroy]
  end

  resources :token_authentications, :only => [:create, :destroy]

  resources :discussions do
    resources :posts
  end

  resources :curriculum_units, :only => [:index, :show]

  root :to => 'sessions#new'

# Sample resource route with more complex sub-resources
#   resources :products do
#     resources :comments
#     resources :sales do
#       get 'recent', :on => :collection
#     end
#   end

# Sample resource route within a namespace:
#   namespace :admin do
#     # Directs /admin/products/* to Admin::ProductsController
#     # (app/controllers/admin/products_controller.rb)
#     resources :products
#   end

# This is a legacy wild controller route that's not recommended for RESTful applications.
# Note: This route will make all actions in every controller accessible via GET requests.
# match ':controller(/:action(/:id(.:format)))'
end
