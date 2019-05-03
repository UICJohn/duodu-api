class Users::ProfilesController < ApplicationController
  before_action :authenticate_user!
  def update
    @user = current_user
    if @user.update_attributes(profiles_params)
      render 'users/show'
    else
      error!(current_user.errors)
    end
  end

  private
  def profiles_params
    params.require(:profiles).permit(:intro, :city, :country, :suburb, :province, :gender, :username, :avatar)
  end
end