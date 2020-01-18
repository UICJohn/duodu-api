class NotificationsWorker
  include Sidekiq::Worker

  def perform(model, id)
    if target = model.constantize.find_by(id: id)
      target.receivers.each do |receiver|
        unless target.delivered?(receiver)
          if ActionCable.server.broadcast( "#{target.channel_prefix}_#{receiver.id}", target.notifying_package).positive?
            target.create_delivered_record!(receiver)
          end
        end
      end
    end
  end
end
