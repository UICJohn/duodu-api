Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  require 'sidekiq/web'
  if Rails.env.staging? or Rails.env.development?
    mount Sidekiq::Web => '/sidekiq'
  end

  devise_for :users, defaults: { format: :json }, controllers: { sessions: 'users/sessions', registrations: 'users/registrations', passwords: 'users/passwords'}

  devise_scope :user do
    get "/users/send_verify_code" => "users/registrations#send_verify_code"
    get "/users/send_reset_password_vcode" => "users/passwords#send_verify_code"
  end

  namespace 'v1' do
    put "/profiles" => "profiles#update"
    put "/profiles/update_password" => "profiles#update_password"
    get "/profiles" => "profiles#show"
    post "/profiles/add_tag" => "profiles#add_tag"
    post "/profiles/upload_avatar" => "profiles#upload_avatar"
    delete "/profiles/delete_tag" => "profiles#delete_tag"
    resources :tags, only: [:index]
  end

  match '*a', :to => 'errors#not_found', via: :get
end