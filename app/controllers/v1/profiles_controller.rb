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


  def update_password
    @user = current_user
    if params[:user][:current_password].present?
      if @user.valid_password?(params[:user][:current_password])
        if @user.update(password: params[:user][:password])
          bypass_sign_in(@user)
          success!({message: '成功更新密码'})
        end
      else
        error!({error: {current_password: "密码不正确"}})
      end
    else
      error!({error: {current_password: "请输入原密码"}})      
    end
  end

  private
  def profiles_params
    params.require(:profiles).permit(
      :intro, 
      :city, 
      :country, 
      :suburb, 
      :gender, 
      :occupation, 
      :username, 
      :avatar,  
      :first_name, 
      :last_name, 
      :major, 
      :school, 
      :email, 
      preference_attributes: [
        :id,
        :show_privacy_data,
        :share_location,
        :receive_all_message
      ]
    )
  end  
end