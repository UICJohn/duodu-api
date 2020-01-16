module Notifiable
  extend ActiveSupport::Concern

  included do
    attr_reader :receivers

    after_create :notify

    def channel_prefix
      "#{self.class.to_s.downcase.pluralize}"
    end

    def notifying_package
      %i[title body].map { |col| [col, public_send(col)] if respond_to?(col) }.to_h
    end

    def receivers
      @receivers ||= [self.user]
    end

    def resend!
      NotificationsWorker.perform_async(self.class.to_s, self.id)
    end

    private

    def notify
      NotificationsWorker.perform_async(self.class.to_s, self.id)
    end

  end
end