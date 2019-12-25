class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :target, polymorphic: true, optional: true
  belongs_to :template, class_name: 'NotificationTemplate', foreign_key: :template_id
  enum status: { ready: 0, sent: 1, read: 2 }

  %i[title body].each do |attr_name|
    define_method "#{attr_name}" do
      eval('"' + template.send(attr_name) + '"')  
    end
  end

end
