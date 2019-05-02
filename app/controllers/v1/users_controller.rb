class V1::UsersController < ApplicationController
  before_action :authenticate_user!, only: [:index]

  def show
    @user = current_user
  end

  def update

  end

  private
  def users_params
    # params.require
  end
end