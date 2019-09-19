require 'rails_helper'

RSpec.describe 'Verification Code', :type => :request do
  describe '#create' do
    before do
      @user = create :wechat_user
      @headers = Devise::JWT::TestHelpers.auth_headers({'Accept' => 'application/json' }, @user)
      SendVerificationCodeWorker.clear
    end

    it 'should enqueue code worker' do
      allow_any_instance_of(V1::VerificationCodeController).to receive(:is_wechat?).and_return(true)
      post '/v1/verification_code', params: {
        email: 'john@duodu.com'
      }, headers: @headers
      expect(SendVerificationCodeWorker.jobs.size).to eq 1
    end

    it 'should enqueue code worker' do
      user = create :web_user
      headers = Devise::JWT::TestHelpers.auth_headers({'Accept' => 'application/json' }, user)

      post '/v1/verification_code', params: {
        email: 'user@duodu.com'
      }, headers: headers
      expect(SendVerificationCodeWorker.jobs.size).to eq 1
    end

    it 'should not enqueue code worker' do
      user = create :web_user, email: "john@duodu.com"
      post '/v1/verification_code', params: {
        email: 'john@duodu.com'
      }
      expect(SendVerificationCodeWorker.jobs.size).to eq 0
    end

    it 'should not send code' do
      user = create :web_user, email: "john@duodu.com", phone: '17192033102'
      post '/v1/verification_code', params: {
        email: 'john@duodu.com',
        phone: '17192033101'
      }
      expect(SendVerificationCodeWorker.jobs.size).to eq 0
    end

    it 'should not enqueue code worker' do
      post '/v1/verification_code', params: {
        blabla: 'john@duodu.com'
      }, headers: {'Accept' => 'application/json' }
      expect(SendVerificationCodeWorker.jobs.size).to eq 0
    end

    it 'should not enqueue code worker' do
      user = create :web_user, email: 'user@duodu.com'
      post '/v1/verification_code', params: {
        email: 'user@duodu.com'
      }, headers: {'Accept' => 'application/json' }
      expect(SendVerificationCodeWorker.jobs.size).to eq 0
    end
  end
end
