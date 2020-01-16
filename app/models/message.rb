class Message < ApplicationRecord
  include Traceable
  include Notifiable

  belongs_to :chat_room
  belongs_to :user
  has_many :delivery_logs, as: :target
  has_one_attached :image
  has_one_attached :audio
  has_one_attached :video

  default_scope { order('id DESC') }
  scope :not_delivered, -> { joins("left join delivery_logs on delivery_logs.target_id = messages.id and target_type='Message'").where('delivery_logs.id IS NULL') }

  validate :content_validator
  validate :duplicated?


  def create_delivered_record(user)

  end

  def notifying_package
    package = {
      body: body,
      room_id: chat_room.id,
      tracer: tracer,
      user: { avatar: user.avatar.url, id: user.id }
    }
    package[:audio] = audio.url if audio.attached?
    package[:video] = video.url if video.attached?
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
    unless [body.present?, audio.attached?, video.attached?].count(true) == 1
      errors.add(:base, 'Invalid Message')
    end
  end

  def duplicated?
    errors.add(:base, 'invalid message') unless self.user.chat_rooms.include?(self.chat_room)
  end
end
