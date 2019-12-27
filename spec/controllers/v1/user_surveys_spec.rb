require 'rails_helper'
require 'devise/jwt/test_helpers'
require 'rake'
load File.join(Rails.root, 'lib', 'tasks', 'posts.rake')

RSpec.describe 'Post Comments', type: :request do
  before do
    @user = create :wechat_user
    create :notification_template, tag: 'comment'
    create :notification_template, tag: 'reply'
    @headers = Devise::JWT::TestHelpers.auth_headers({ 'Accept' => 'application/json' }, @user)
  end


  describe '#survey' do
    it 'should get survey' do
      survey = create :survey
      survey_option1 = create :survey_option, survey_id: survey.id
      survey_option2 = create :survey_option, survey_id: survey.id
      survey_option3 = create :survey_option, survey_id: survey.id
      get '/v1/report_posts/survey', params: { survey_name: survey.code_name}, headers: @headers
      expect(response).to be_successful
    end
  end

  describe '#create' do
    before do
      @survey = create :survey
      @survey_option1 = create :survey_option, survey_id: @survey.id
      @survey_option2 = create :survey_option, survey_id: @survey.id
      @survey_option3 = create :survey_option, survey_id: @survey.id
      @post = create :sharehouse
    end

    it 'should create new user_survey' do
      expect{
        post '/v1/report_posts/', params: {post_id: @post.id, report: { survey_option_id: @survey_option2.id, body: "", survey_id: @survey.id }}, headers: @headers
      }.to change(UserSurvey, :count).by 1
      expect(response).to be_successful
    end

    it 'should create new user_survey' do
      expect{
        post '/v1/report_posts/', params: { post_id: @post.id, report: { survey_id: @survey.id, survey_option_id: @survey_option3.id, body: 'option 3' }}, headers: @headers
      }.to change(UserSurvey, :count).by 1
      expect(response).to be_successful
    end

  end
end
