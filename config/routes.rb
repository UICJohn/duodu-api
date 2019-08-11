Rails.application.routes.draw do
  resources :friend_requests
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  require 'sidekiq/web'
  if Rails.env.staging? or Rails.env.development?
    mount Sidekiq::Web => '/sidekiq'
  end

  devise_for :users, defaults: { format: :json }, controllers: { sessions: 'users/sessions', registrations: 'users/registrations', passwords: 'users/passwords'}

  devise_scope :user do
    post "/users/wechat_auth" => "users/sessions#wechat_auth"
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
    put  "/profiles/update_phone" => "profiles#update_phone"

    resources :friend_requests, only: [:create, :destroy, :update]

    resources :tags, only: [:index]

    resources :schools, only: [:index]
    resources :occupations, only: [:index]
  end

  match '*a', :to => 'errors#not_found', via: :get
end