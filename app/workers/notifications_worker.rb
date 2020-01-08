class NotificationsWorker
  include Sidekiq::Worker
  def perform(notification_id)
    if (notification = Notification.find_by(id: notification_id))
      ActionCable.server.broadcast(
        "notification_#{notification.user_id}",
        {
          title: notification.title,
          body:  notification.body
        }
      )
    end
  end
end