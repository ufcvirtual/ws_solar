WsSolar::Application.routes.draw do
  devise_for :users, :controllers => { :sessions => "sessions" }, :only => [:new]

  devise_scope :user do
    get "logout", :to => "sessions#destroy"
    resources :sessions, :only => [:new, :create, :destroy]
  end

  resources :token_authentications, :only => [:create, :destroy]

  # curriculum_units/:id/groups/
  resources :curriculum_units, :only => [:index, :show] do
    resources :groups, :only => [:index, :show]
  end

  # groups/:id/discussions
  resources :groups, :only => [] do # nao existe uma consulta direta a turmas
    resources :discussions, :only => [:index, :show]
  end

  # discussions/:id/posts
  resources :discussions, :only => [:show] do
    resources :posts
    controller :posts do
      # news
      match "posts/:date/news" => :list, :type => "news"
      match "posts/:date/news/:order/order" => :list, :type => "news"
      match "posts/:date/news/:limit/limit" => :list, :type => "news"
      match "posts/:date/news/:order/order/:limit/limit" => :list, :type => "news"
      # history
      match "posts/:date/history" => :list, :type => "history"
      match "posts/:date/history/:order/order" => :list, :type => "history"
      match "posts/:date/history/:limit/limit" => :list, :type => "history"
      match "posts/:date/history/:order/order/:limit/limit" => :list, :type => "history"
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
