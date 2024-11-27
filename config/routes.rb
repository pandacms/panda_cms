require_relative "../app/constraints/panda_cms/admin_constraint"

PandaCms::Engine.routes.draw do
  constraints PandaCms::AdminConstraint.new(&:present?) do
    namespace PandaCms.route_namespace, as: :admin, module: :admin do
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

      if Rails.env.development?
        mount Lookbook::Engine, at: "/lookbook"
      end
    end

    get PandaCms.route_namespace, to: "admin/dashboard#show", as: :admin_dashboard
  end

  ### PUBLIC ROUTES ###

  # Authentication routes
  get PandaCms.route_namespace, to: "admin/sessions#new", as: :admin_login
  # Get and post options here are for OmniAuth coming back in, not going out
  match "#{PandaCms.route_namespace}/auth/:provider/callback", to: "admin/sessions#create", as: :admin_login_callback, via: %i[get post]
  match "#{PandaCms.route_namespace}/auth/failure", to: "admin/sessions#failure", as: :admin_login_failure, via: %i[get post]
  # OmniAuth additionally adds a GET route for "#{PandaCms.route_namespace}/auth/:provider" but doesn't name it
  delete PandaCms.route_namespace, to: "admin/sessions#destroy", as: :admin_logout

  if PandaCms.config.posts[:enabled]
    # TODO: Allow multiple types of post in future
    # TODO: This now requires a page to be created, make it explicit (with a rendering posts helper?)
    # get PandaCms.posts[:prefix], to: "posts#index", as: :posts
    get "#{PandaCms.config.posts[:prefix]}/:slug", to: "posts#show", as: :post
  end

  ### APPENDED ROUTES ###

  # See lib/panda_cms/engine.rb
  mount Panda::Cms::Engine => "/"
end
