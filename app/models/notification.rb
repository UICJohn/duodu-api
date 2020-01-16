class Notification < ApplicationRecord
  include Traceable
  belongs_to :receiver, class_name: 'User'
  belongs_to :sender, class_name: 'User', optional: true
  belongs_to :target, polymorphic: true, optional: true
  belongs_to :template, class_name: 'NotificationTemplate', foreign_key: :template_id
  has_many :delivery_logs, as: :target

  enum status: { ready: 0, sent: 1, read: 2 }

  scope :systems, -> { joins(:template).where("code = 'sys'") }
  scope :comments, -> { joins(:template).where("code = 'comment' or code = 'reply'") }
  scope :unread, -> { where("status != ?", Notification.statuses[:read]) }

  %i[title body].each do |attr_name|
    define_method "#{attr_name}" do
      eval('"' + template.send(attr_name) + '"')  
    end
  end

  def receivers
    @receivers ||= [self.receiver]
  end  
end
