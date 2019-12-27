FactoryBot.define do
  factory :survey_option do
    survey
    position { 1 }
    body { 'option' }
    custom_option { false }
  end
end
