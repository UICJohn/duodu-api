require 'rails_helper'

RSpec.describe UserSurvey, type: :model do

  describe 'validations#uniqueness' do
    before do
      @post = create :sharehouse
      @user = create :wechat_user
      @survey = create :survey
      @survey_option1 = create :survey_option, survey_id: @survey.id
      @survey_option2 = create :survey_option, survey_id: @survey.id
      @survey_option3 = create :survey_option, survey_id: @survey.id
    end
    it 'should able to create user_survey' do
      expect {
        create :user_survey, survey_id: @survey.id, survey_option_id: @survey_option1.id
      }.to change(UserSurvey, :count).by 1
    end

    it 'should able to create duplicate user_survey without target' do
      expect {
        create :user_survey, survey_id: @survey.id, survey_option_id: @survey_option1.id
      }.to change(UserSurvey, :count).by 1

      expect {
        create :user_survey, survey_id: @survey.id, survey_option_id: @survey_option1.id
      }.to change(UserSurvey, :count).by 1
    end

    it 'should not able to create user_survey' do
      create :user_survey, survey_id: @survey.id, survey_option_id: @survey_option1.id, user_id: @user.id, target: @post
      user_survey = build :user_survey, survey_id: @survey.id, survey_option_id: @survey_option1.id, user_id: @user.id, target: @post
      expect(user_survey.valid?).to eq false
      expect(user_survey.errors.full_messages).to include("User survey record already exists")
    end
  end

  describe 'validations#custom_option_body_should_present' do
    before do
      @post = create :sharehouse
      @survey = create :survey
      @survey_option1 = create :survey_option, survey_id: @survey.id
      @survey_option2 = create :survey_option, survey_id: @survey.id
      @survey_option3 = create :survey_option, survey_id: @survey.id, custom_option: true
    end

    it 'should contains body for custom option' do
      user_survey = build :user_survey, survey_id: @survey.id, survey_option_id: @survey_option3.id, body: nil
      expect(user_survey.valid?).to eq false
      expect(user_survey.errors.full_messages).to include('Body content should present')
    end
  end

  describe '#reset_body' do
    it 'should reset body if not a custom option' do
      survey = create :survey
      survey_option1 = create :survey_option, survey_id: survey.id
      survey_option2 = create :survey_option, survey_id: survey.id
      survey_option3 = create :survey_option, survey_id: survey.id, custom_option: true
      user_survey = create :user_survey, survey_id: survey.id, survey_option_id: survey_option1.id, body: 'blablabla'
      user_survey.reload
      expect(user_survey.body).to eq nil
    end

    it 'should not reset body if a custom option' do
      survey = create :survey
      survey_option1 = create :survey_option, survey_id: survey.id
      survey_option2 = create :survey_option, survey_id: survey.id
      survey_option3 = create :survey_option, survey_id: survey.id, custom_option: true
      user_survey = create :user_survey, survey_id: survey.id, survey_option_id: survey_option3.id, body: 'blablabla'
      user_survey.reload
      expect(user_survey.body).to eq 'blablabla'
    end
  end
end
