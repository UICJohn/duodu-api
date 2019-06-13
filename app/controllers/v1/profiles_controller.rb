class V1::ProfilesController < ApplicationController
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


  def upload_avatar
    if params[:file].present?
      @user = current_user
      @user.avatar = params[:file]
      if @user.save
        render :show
      else
        error!({error: @user.errors})
      end
    else
      error!({error: '哎呀，出错了！'})
    end
  end

  def add_tag
    if params[:tag].present?
      @user = current_user
      if not @user.tags.include?(params[:tag])
        @user.tags << params[:tag]
        if @user.save
          render :show
        else
          error!({error: @user.errors})    
        end
      else
        error!({error: '标签已添加'})
      end
    else
      error!({error: '哎呀，出错了！'}) 
    end
    
  end

  def delete_tag
    if params[:tag].present?
      @user = current_user
      if @user.tags.include?(params[:tag])
        @user.tags.delete(params[:tag])
        if @user.save
          render :show
        else
          error!({error: @user.errors})
        end
      end
    else
      error!({error: '哎呀，出错了！'})
    end
  end

  private
  def profiles_params
    params.require(:profiles).permit(:intro, :city, :country, :suburb, :gender, :occupation, :username, :avatar,  :first_name, :last_name, :major, :school)
  end
end