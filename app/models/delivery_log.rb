class DeliveryLog < ApplicationRecord
  belongs_to :target, polymorphic: true
  belongs_to :user

  validates_uniqueness_of :user, scope: [ :target ], message: "Package already delivered"
  validate :self_message?

  enum delivery_method: { action_cable: 0, controller: 1 }

  def self.create_delivered_record!(target, user, delivery_method = 0)
    DeliveryLog.where(target: target, user: user, delivery_method: delivery_method).first_or_create
  end

  private
  def self_message?
    if target.user == user
      errors.add(:base, 'try to create delivery log for self message')
    end
  end
end