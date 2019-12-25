class Comment < ApplicationRecord
  include Traceable

  validates :body, presence: true

  belongs_to :user
  belongs_to :target, polymorphic: true
  has_many :comments, as: :target
  has_many :notifications, as: :target

  after_create :create_notification

  def sub_comments
    [ comments.to_a, comments.map { |comment| comment.sub_comments if comment.comments.present? } ].flatten.compact.uniq.sort_by(&:id)
  end

  def root
    root_target = self
    loop do
      root_target = root_target.target
      break unless root_target.is_a?(Comment)
    end
    root_target
  end

  private

  def create_notification
    if template = NotificationTemplate.find_by(tag: (target.is_a?(Comment) ? 'reply' : 'comment'))
      Notification.create!(
        user_id: target.user_id,
        target: self,
        status: 0,
        template_id: template.id
      )
    end
  end

end
