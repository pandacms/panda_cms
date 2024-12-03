require_relative "../app/constraints/panda/cms/admin_constraint"

Panda::CMS::Engine.routes.draw do
  constraints Panda::CMS::AdminConstraint.new(&:present?) do
    namespace Panda::CMS.route_namespace, as: :admin, module: :admin do
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

    get Panda::CMS.route_namespace, to: "admin/dashboard#show", as: :admin_dashboard
  end

  ### PUBLIC ROUTES ###

  # Authentication routes
  get Panda::CMS.route_namespace, to: "admin/sessions#new", as: :admin_login
  # Get and post options here are for OmniAuth coming back in, not going out
  match "#{Panda::CMS.route_namespace}/auth/:provider/callback", to: "admin/sessions#create", as: :admin_login_callback, via: %i[get post]
  match "#{Panda::CMS.route_namespace}/auth/failure", to: "admin/sessions#failure", as: :admin_login_failure, via: %i[get post]
  # OmniAuth additionally adds a GET route for "#{Panda::CMS.route_namespace}/auth/:provider" but doesn't name it
  delete Panda::CMS.route_namespace, to: "admin/sessions#destroy", as: :admin_logout

  if Panda::CMS.config.posts[:enabled]
    # TODO: Allow multiple types of post in future
    # TODO: This now requires a page to be created, make it explicit (with a rendering posts helper?)
    # get Panda::CMS.posts[:prefix], to: "posts#index", as: :posts
    get "#{Panda::CMS.config.posts[:prefix]}/:slug", to: "posts#show", as: :post
  end

  ### APPENDED ROUTES ###

  # See lib/panda/cms/engine.rb
end
