WsSolar::Application.routes.draw do
  devise_for :users, :controllers => { :sessions => "sessions" }, :only => [:new]

  devise_scope :user do
    get "logout", :to => "devise/sessions#destroy"
    resources :sessions, :only => [:new, :create, :destroy]
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
  resources :discussions, :only => [:show] do
    resources :posts
    controller :posts do
      match "posts/:date/news" => :news
      match "posts/:date/history" => :history
    end
  end

  # anexo de arquivos a um post
  resources :posts, :only => [:attach_file] do
    post :attach_file, :on => :member
  end

  resources :images, :only => [:users, :individual_user] do
    get :users, :on => :member
    get :individual_user, :on => :member
  end

  # acessando fotos do usuario
  match "/users/:id/photos/:style.:extension" => "images#users"

  root :to => "home#index"
end
