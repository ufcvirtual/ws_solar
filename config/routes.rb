WsSolar::Application.routes.draw do

  get "home/index"

  devise_for :users, :controllers => { :sessions => "sessions" }

  devise_scope :user do
    get "logout", :to => "devise/sessions#destroy"
    resources :sessions, :only => [:create, :destroy]
  end

  resources :token_authentications, :only => [:create, :destroy]

  # curriculum_units/:id/groups/
  resources :curriculum_units, :only => [:index, :show] do
    resources :groups, :only => [:index, :show]
  end

  # groups/:id/discussions
  resources :groups, :only => [:show] do
    resources :discussions, :only => [:index, :show]
  end

  # discussions/:id/posts
  resources :discussions do
    resources :posts
  end

  root :to => "home#index"

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
