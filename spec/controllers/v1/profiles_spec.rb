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
          gender: 'male', 
          occupation: 'programmer', 
          dob: '2019-12-01',
          location_attributes: {
            id: @user.location.id,
            latitude: 45.21,
            longitude: 123.23
          }
        }
      }, headers: @headers

      @user.reload
      expect(response).to be_successful
      expect(@user.intro).to eq 'introduction'
      expect(@user.location.city.name).to eq '惠州市'
      expect(@user.location.country.name).to eq '中国'
      expect(@user.location.province.name).to eq '广东省'
      expect(@user.location.suburb.name).to eq '惠城区'
      expect(@user.gender).to eq 'male'
      expect(@user.occupation).to eq 'programmer'
      expect(@user.dob).to eq Date.new(2019, 12, 1)
    end

    it 'should not allow user to update profile' do
      put '/v1/profiles', params: {
        profiles: {
          intro: 'introduction', 
          gender: 'male', 
          occupation: 'programmer', 
          dob: '2019-12-01',
          location_attributes: {
            city: 'xian', 
            country: 'CN', 
            province: 'shanxi', 
            suburb: 'xincheng',  
          }
        }
      }

      @user.reload
      expect(response).not_to be_successful
      expect(@user.intro).to eq nil
      expect(@user.location.city.name).to eq '惠州市'
      expect(@user.location.country.name).to eq '中国'
      expect(@user.location.province.name).to eq '广东省'
      expect(@user.location.suburb.name).to eq '惠城区'
      expect(@user.gender).to eq '0'
      expect(@user.occupation).to eq '程序员'
      expect(@user.dob).to eq nil
    end


    it 'should enqueue avartar worker' do
      put '/v1/profiles', params: {
        profiles: {
          avatar_url: 'url_path'
        }
      }, headers: @headers
      expect(FetchAvatarWorker.jobs.size).to eq 1
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
