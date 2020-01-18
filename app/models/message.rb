class Message < ApplicationRecord
  include Notifiable
  include Traceable

  belongs_to :chat_room
  belongs_to :user
  has_one_attached :file

  validate :content_validator
  validate :can_chat?

  default_scope { order('id DESC') }
  scope :not_delivered, ->(user, chat_room) { joins("left join delivery_logs on delivery_logs.target_id = messages.id and target_type='Message'").where('delivery_logs.id IS NULL and chat_room_id = ? and messages.user_id != ?', chat_room.id, user.id) }

  def notifying_package
    package = {
      body: body,
      room_id: chat_room.id,
      tracer: tracer,
      user: { avatar: user.avatar.url, id: user.id }
    }
    package[:file] = file.url if file.attached?
    package
  end

  def receivers
    @receivers ||= chat_room.users.where.not(id: user_id)
  end

  # def ready?
  #   status == 'ready' || status.zero?
  # end

  private

  def content_validator
    if body.present? && file.attached?
      errors.add(:base, 'Invalid Message')
    end
  end

  def can_chat?
    errors.add(:chat_room, 'unauthorize room') unless self.user.chat_rooms.include?(self.chat_room)
  end
end
