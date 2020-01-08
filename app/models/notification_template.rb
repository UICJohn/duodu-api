class NotificationTemplate < ApplicationRecord
  validates :code, presence: true, uniqueness: true
end
