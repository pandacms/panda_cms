require_relative "../app/constraints/panda_cms/admin_constraint"

PandaCms::Engine.routes.draw do
  constraints PandaCms::AdminConstraint.new(&:present?) do
    namespace PandaCms.admin_path_symbol.to_sym, as: :admin, module: :admin do
      resources :files
      resources :forms, only: %i[index show]
      resources :menus
      resources :pages do
        resources :block_contents, only: %i[update]
      end
      resources :posts

      get "settings", to: "settings#index"
      namespace :settings, as: :settings do
        get "bulk_editor", to: "bulk_editor#new"
        post "bulk_editor", to: "bulk_editor#create"
      end
    end

    get PandaCms.admin_path, to: "admin/dashboard#show", as: :admin_dashboard
  end

  ### PUBLIC ROUTES ###

  # Authentication routes
  get PandaCms.admin_path, to: "admin/sessions#new", as: :admin_login
  # Get and post options here are for OmniAuth coming back in, not going out
  match "#{PandaCms.admin_path}/auth/:provider/callback", to: "admin/sessions#create", as: :admin_login_callback, via: %i[get post]
  match "#{PandaCms.admin_path}/auth/failure", to: "admin/sessions#failure", as: :admin_login_failure, via: %i[get post]
  # OmniAuth additionally adds a GET route for "#{PandaCms.admin_path}/auth/:provider" but doesn't name it
  delete PandaCms.admin_path, to: "admin/sessions#destroy", as: :admin_logout

  if PandaCms.posts
    # TODO: Allow multiple types of post in future
    get PandaCms.posts[:prefix], to: "posts#index", as: :posts
    get "#{PandaCms.posts[:prefix]}/:slug", to: "posts#show", as: :post
  end

  ### APPENDED ROUTES ###

  # See lib/panda_cms/engine.rb
end
