class Message < ApplicationRecord
  include Notifiable
  include Traceable

  belongs_to :conversation
  belongs_to :sender, class_name: 'User', foreign_key: 'user_id'
  has_one_attached :file

  validate :content_validator
  validate :can_chat?

  default_scope { order('id DESC') }

  delegate :chat_room, to: :conversation

  def self.not_delivered(user, chat_room)
    if user.chat_rooms.include?(chat_room)
      conversations = chat_room.conversations
      joins("left join delivery_logs on delivery_logs.target_id = messages.id and target_type='Message'").where('delivery_logs.id IS NULL and conversation_id IN (?) and messages.user_id != ?', chat_room.conversation_ids, user.id)
    else
      Message.none
    end
  end

  def notifying_package
    package = {
      body: body,
      room_id: chat_room.id,
      tracer: tracer,
      user: { avatar: sender.avatar.url, id: sender.id }
    }
    package[:file] = file.url if file.attached?
    package
  end

  def receivers
    chat_room.users.where.not(id: sender.id)
  end

  private

  def content_validator
    if body.present? && file.attached?
      errors.add(:base, 'Invalid Message')
    end
  end

  def can_chat?
    errors.add(:chat_room, 'unauthorize room') unless sender.chat_rooms.include?(chat_room)
  end
end
