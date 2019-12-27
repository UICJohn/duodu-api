class UserSurvey < ApplicationRecord
  belongs_to :user
  belongs_to :survey_option
  belongs_to :survey
  belongs_to :target, polymorphic: true, optional: true

  validate :custom_option_body_should_present, if: proc { |us| us.survey_option.present? }
  validates_uniqueness_of :user, scope: [ :target, :survey ], message: "survey record already exists", if: proc { |us| us.target.present? }

  before_validation :reset_body, on: :create, unless: :custom_option?

  private

  def reset_body
    self.body = nil
  end

  def custom_option?
    survey_option.custom_option?
  end

  def custom_option_body_should_present
    if custom_option? and body.blank?
      errors.add(:body, 'content should present')
    end
  end
end