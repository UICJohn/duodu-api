class Survey < ApplicationRecord
  has_many :survey_options

  validates :title, :code_name, presence: true
end