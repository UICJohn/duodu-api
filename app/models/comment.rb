class Comment < ApplicationRecord
  include Traceable

  validates :body, presence: true

  belongs_to :user
  belongs_to :target, polymorphic: true
  has_many :comments, as: :target
  has_many :notifications, as: :target

  after_create :create_notification

  attr_reader :root

  def sub_comments
    [ comments.to_a, comments.map { |comment| comment.sub_comments if comment.comments.present? } ].flatten.compact.uniq.sort_by(&:id)
  end

  def root
    if @root.present?
      @root
    else
      @root = self
      loop do
        @root = @root.target
        break unless @root.is_a?(Comment)
      end
      @root
    end
  end

  private

  def create_notification
    return unless target.user_id == user_id

    if template = NotificationTemplate.find_by(code: (target.is_a?(Comment) ? 'reply' : 'comment'))
      Notification.create!(
        receiver_id: target.user_id,
        sender_id: user_id,
        target: self,
        status: 0,
        template_id: template.id
      )
    end
  end

end
