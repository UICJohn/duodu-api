Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  require 'sidekiq/web'
  if Rails.env.staging? || Rails.env.development?
    mount Sidekiq::Web => '/sidekiq'
  end

  mount ActionCable.server => "/cable"

  devise_for :users, defaults: { format: :json }, controllers: { sessions: 'users/sessions', registrations: 'users/registrations', passwords: 'users/passwords' }

  devise_scope :user do
    post '/users/wechat_auth' => 'users/sessions#wechat_auth'
    get '/users/send_reset_password_vcode' => 'users/passwords#send_verify_code'
  end

  namespace 'v1' do
    put '/profiles' => 'profiles#update'
    put '/profiles/update_password' => 'profiles#update_password'
    get '/profiles' => 'profiles#show'
    post '/profiles/add_tag' => 'profiles#add_tag'
    post '/profiles/upload_avatar' => 'profiles#upload_avatar'
    delete '/profiles/delete_tag' => 'profiles#delete_tag'
    put '/profiles/update_phone' => 'profiles#update_phone'
    put '/profiles/update_email' => 'profiles#update_email'

    resources :friend_requests, only: %i[create destroy update]

    resources :tags, only: [:index]

    resources :posts, only: %i[index create show] do
      post :upload_images
      post :like
      delete :dislike
    end

    resources :verification_code, only: [:create]

    resources :schools, only: [:index]

    resources :suburbs, only: [:index]

    resources :subways, only: [:index]

    resources :report_posts, only: [:create] do
      collection do
        get :survey
      end
    end


    resources :post_comments, only: %i[index create show destroy] do
      member do
        post :reply
      end
    end

    resources :notifications, only: %i[show] do
      collection do
        get :unread_count
      end
    end

    resources :comments, only: %i[index]

  end

  scope format: true, constraints: { format: /jpg|png|gif|PNG/ } do
    match '*a', to: 'errors#not_found', via: :get
  end
end
