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
      @receivers ||= [self.user]
    end

    def resend!
      NotificationsWorker.perform_async(self.class.to_s, self.id)
    end

    def create_delivered_record!(user, delivery_method = 0)
      target.where(user: user, delivery_method: delivery_method).first_or_create
    end

    def delivered?(user)
      self.where(user: user).present?
    end

    private

    def notify
      NotificationsWorker.perform_async(self.class.to_s, self.id)
    end

  end
end