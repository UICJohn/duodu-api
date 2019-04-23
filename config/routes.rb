Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  devise_for :users, defaults: { format: :json }, controllers: { sessions: 'users/sessions', registrations: 'users/registrations' }

  devise_scope :user do
    get "/users/send_verify_code" => "users/registrations#send_verify_code"
  end

end
