class V1::NotificationsController < ApplicationController
  before_action :authenticate_user!

  def show

  end

  def unread_count
    @unread_count = current_user.notifications.unread.count(:id)
    @unread_systems = current_user.notifications.systems.unread.count(:id)
    @unread_comments = current_user.notifications.comments.unread.count(:id)
  end  
end
