Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :v1, defaults: {format: :json} do
    resources :articles
    resources :blogs
    resources :stories
    get '*path', controller: 'application', action: 'render_404'
  end

end
