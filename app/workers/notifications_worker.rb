class NotificationsWorker
  include Sidekiq::Worker

  def perform(model, id)
    if (package = model.constantize.find_by(id: id))
      package.receivers.each do |receiver|
        unless package.delivered?(receiver)
          if ActionCable.server.broadcast( "#{package.channel_prefix}_#{receiver.id}", package.notifying_package).positive?
            package.create_delivered_record!(receiver)
          end
        end
      end
    end
  end
end
