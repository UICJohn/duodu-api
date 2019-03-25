Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  devise_for :users, skip: :all

  devise_scope :user do
    post '/users' => "users/registrations#create"
    get "/users/send_verify_code" => "users/registrations#send_verify_code"
  end

end
