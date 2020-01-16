class DeliveryLog < ApplicationRecord
  belongs_to :target, polymorphic: true
  belongs_to :user

  validates_uniqueness_of :user, scope: [ :target ], message: "Package already delivered"

  enum delivery_method: { action_cable: 0, controller: 1 }

  def self.delivered!(target, user, delivery_method = 0)
    DeliveryLog.where(target: target, user: user, delivery_method: delivery_method).first_or_create
  end

  def self.delivered?(target, user)
    DeliveryLog.where(target: target, user: user).present?
  end
end