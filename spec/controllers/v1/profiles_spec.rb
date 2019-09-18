require 'rails_helper'
require 'devise/jwt/test_helpers'

RSpec.describe 'Profile', :type => :request do
  describe '#update' do
    before do
      @user = create :wechat_user
      @headers = Devise::JWT::TestHelpers.auth_headers({'Accept' => 'application/json' }, @user)
    end

    it 'should update user profile' do
      put '/v1/profiles', params: {
        profiles: {
          intro: 'introduction', 
          city: 'xian', 
          country: 'CN', 
          province: 'shanxi', 
          suburb: 'xincheng',  
          gender: 'male', 
          occupation: 'programmer', 
          dob: '2019-12-01'
        }
      }, headers: @headers

      @user.reload
      expect(response).to be_successful
      expect(@user.intro).to eq 'introduction'
      expect(@user.city).to eq 'xian'
      expect(@user.country).to eq 'CN'
      expect(@user.province).to eq 'shanxi'
      expect(@user.suburb).to eq 'xincheng'
      expect(@user.gender).to eq 'male'
      expect(@user.occupation).to eq 'programmer'
      expect(@user.dob).to eq Date.new(2019, 12, 1)
    end

    it 'should not allow user to update profile' do
      put '/v1/profiles', params: {
        profiles: {
          intro: 'introduction', 
          city: 'xian', 
          country: 'CN', 
          province: 'shanxi', 
          suburb: 'xincheng',  
          gender: 'male', 
          occupation: 'programmer', 
          dob: '2019-12-01'
        }
      }

      @user.reload
      expect(response).not_to be_successful
      expect(@user.intro).to eq nil
      expect(@user.city).to eq nil
      expect(@user.country).to eq nil
      expect(@user.province).to eq nil
      expect(@user.suburb).to eq nil
      expect(@user.gender).to eq '0'
      expect(@user.occupation).to eq '程序员'
      expect(@user.dob).to eq nil
    end
  end

  describe '#update_email' do

    before do
      @user = create :wechat_user
      @headers = Devise::JWT::TestHelpers.auth_headers({'Accept' => 'application/json' }, @user)
    end

    it 'should update email' do
      allow_any_instance_of(VerificationCode).to receive(:verified?).and_return(true)
      put '/v1/profiles/update_email', params: {
        email: 'john@duodu.com',
        code: 'D-122345'
      }, headers: @headers

      @user.reload
      expect(response).to be_successful
      expect(@user.email).to eq 'john@duodu.com'
    end

    it 'should not update email' do
      allow_any_instance_of(VerificationCode).to receive(:verified?).and_return(true)
      put '/v1/profiles/update_email', params: {
        email: 'john@duodu.com',
        code: 'D-122345'
      }

      @user.reload
      expect(response).not_to be_successful
      expect(@user.email).to eq nil
    end

    it 'should not update email' do
      allow_any_instance_of(VerificationCode).to receive(:verified?).and_return(false)
      put '/v1/profiles/update_email', params: {
        email: 'john@duodu.com',
        code: 'D-122345'
      }, headers: @headers

      @user.reload
      expect(response).not_to be_successful
      expect(@user.email).to eq nil
    end
  end

  describe '#update_phone' do
    before do
      @user = create :wechat_user
      @headers = Devise::JWT::TestHelpers.auth_headers({'Accept' => 'application/json' }, @user)
    end

    it 'should update phone' do
      allow_any_instance_of(VerificationCode).to receive(:verified?).and_return(true)
      put '/v1/profiles/update_phone', params: {
        phone: '17281928192',
        code: 'D-122345'
      }, headers: @headers

      @user.reload
      expect(response).to be_successful
      expect(@user.phone).to eq '17281928192'
    end

    it 'should not update phone' do
      allow_any_instance_of(VerificationCode).to receive(:verified?).and_return(true)
      put '/v1/profiles/update_phone', params: {
        phone: '17281928192',
        code: 'D-122345'
      }

      @user.reload
      expect(response).not_to be_successful
      expect(@user.phone).to eq nil
    end

    it 'should not update phone' do
      allow_any_instance_of(VerificationCode).to receive(:verified?).and_return(false)
      put '/v1/profiles/update_phone', params: {
        phone: '17281928192',
        code: 'D-122345'
      }, headers: @headers

      @user.reload
      expect(response).not_to be_successful
      expect(@user.phone).to eq nil
    end
  end
end
