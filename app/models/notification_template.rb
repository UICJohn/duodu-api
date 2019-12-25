class NotificationTemplate < ApplicationRecord
  enum tag: { sys: 0, comment: 1, reply: 2}
end
