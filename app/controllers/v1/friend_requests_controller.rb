class V1::FriendRequestsController < ApplicationController
  before_action :authenticate_user!

  def create
    @friend_request = current_user.friend_requests.build(friend_request_params)
    if @friend_request.save
      success!(message: '已发送好友请求')
    else
      error!(error: @friend_request.errors)
    end
  end

  def update; end

  def destroy
    if (friend_request = current_user.friend_requests.where(id: params[:id]))
      if friend_request.destroy
        success!(message: '已取消好友请求')
      else
        error!(error: friend_request.errors)
      end
    else
      success!(message: '已取消好友请求')
    end
  end

  private

  def friend_request_params
    params.require(:friend_request).permit(:friend_id)
  end
end
