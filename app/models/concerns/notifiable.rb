module Notifiable
  extend ActiveSupport::Concern

  included do
    attr_reader :receivers

    has_many :delivery_logs, as: :target

    after_create :notify

    def channel_prefix
      "#{self.class.to_s.downcase.pluralize}"
    end

    def notifying_package
      %i[title body].map { |col| [col, public_send(col)] if respond_to?(col) }.to_h
    end

    def receivers
      raise 'You should implement this method'
    end

    def resend!
      NotificationsWorker.perform_async(self.class.to_s, self.id)
    end

    def create_delivered_record!(user, delivery_method = 0)
      DeliveryLog.create_delivered_record!(self, user, delivery_method)
    end

    def delivered?(user)
      DeliveryLog.where(user: user, target: self).present?
    end

    private

    def notify
      NotificationsWorker.perform_async(self.class.to_s, self.id)
    end

  end
end