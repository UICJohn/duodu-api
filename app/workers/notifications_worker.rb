class NotificationsWorker
  include Sidekiq::Worker

  def perform(model, id)
    if target = model.constantize.find_by(id: id)
      target.receivers.each do |receiver|
        unless DeliveryLog.delivered?(target, receiver)
          if ActionCable.server.broadcast( "#{target.channel_prefix}_#{receiver.id}", target.notifying_package)
            DeliveryLog.delivered!(target, receiver)
          end
        end
      end
    end
  end
end
