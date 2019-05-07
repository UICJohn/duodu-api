class Users::ProfilesController < ApplicationController
  before_action :authenticate_user!
  def update
    @user = current_user
    if @user.update_attributes(profiles_params)
      render :show
    else
      error!(current_user.errors)
    end
  end


  def show
    @user = current_user
  end

  private
  def profiles_params
    params.require(:profiles).permit(:intro, :city, :country, :suburb, :province, :gender, :username, :avatar, :tag_ids)
  end
end