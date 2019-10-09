require 'rails_helper'
require 'devise/jwt/test_helpers'

RSpec.describe 'Post', :type => :request do
  before do
    @user = create :wechat_user
    @headers = Devise::JWT::TestHelpers.auth_headers({'Accept' => 'application/json' }, @user)
    4.times{ create :takehouse }
    4.times{ create :sharehouse }
    4.times{ create :housemate }
  end

  describe "index" do
    it 'should success' do
      get "/v1/posts", params: {}, headers: @headers
      expect(response).to be_successful
      posts = JSON.load(response.body)["posts"]
      expect(posts.count).to eq 10
    end

    it 'should success' do
      get "/v1/posts", params: {page: 2}, headers: @headers
      expect(response).to be_successful
      posts = JSON.load(response.body)["posts"]
      expect(posts.count).to eq 2
    end

    it 'should filter posts with location' do
      country  = create :country, name: "中国"
      province = create :province, name: '江苏省', parent_id: country.id
      city = create :city, name: '南京市', parent_id: province.id
      suburb = create :suburb, name: "浦口区", parent_id: city.id
      post = build :takehouse
      post.location = build :location, city: city, suburb: suburb, province: province
      post.save

      get "/v1/posts", params: {filters: {city: "南京市"}}, headers: @headers
      expect(response).to be_successful
      posts = JSON.load(response.body)["posts"]
      expect(posts.count).to eq 1
    end

    it 'should filter posts with location' do
      country  = create :country, name: "中国"
      province = create :province, name: '江苏省', parent_id: country.id
      city = create :city, name: '南京市', parent_id: province.id
      suburb = create :suburb, name: "浦口区", parent_id: city.id
      post = build :takehouse
      post.location = build :location, city: city, suburb: suburb, province: province
      post.save

      get "/v1/posts", params: {filters: {city: "南京市"}}, headers: @headers
      expect(response).to be_successful
      posts = JSON.load(response.body)["posts"]
      expect(posts.count).to eq 1
    end 

    it 'should filter posts with location' do
      country  = create :country, name: "中国"
      province = create :province, name: '江苏省', parent_id: country.id
      city = create :city, name: '南京市', parent_id: province.id
      suburb = create :suburb, name: "浦口区", parent_id: city.id
      suburb1 = create :suburb, name: "秦淮区", parent_id: city.id
      post = build :takehouse
      post.location = build :location, city: city, suburb: suburb, province: province
      post.save

      post = build :takehouse
      post.location = build :location, city: city, suburb: suburb1, province: province
      post.save

      get "/v1/posts", params: {filters: {city: "南京市"}}, headers: @headers
      expect(response).to be_successful
      posts = JSON.load(response.body)["posts"]
      expect(posts.count).to eq 2
    end


    it 'should filter posts with location' do
      country  = create :country, name: "中国"
      province = create :province, name: '江苏省', parent_id: country.id
      city = create :city, name: '南京市', parent_id: province.id
      suburb1 = create :suburb, name: "浦口区", parent_id: city.id
      suburb2 = create :suburb, name: "秦淮区", parent_id: city.id
      post = build :takehouse
      post.location = build :location, city: city, suburb: suburb1, province: province
      post.save

      post = build :takehouse
      post.location = build :location, city: city, suburb: suburb2, province: province
      post.save


      get "/v1/posts", params: {filters: {suburb: "浦口区"}}, headers: @headers
      expect(response).to be_successful
      posts = JSON.load(response.body)["posts"]
      expect(posts.count).to eq 1
    end

    it 'should filter user gender' do
      country  = create :country, name: "中国"
      province = create :province, name: '江苏省', parent_id: country.id
      city = create :city, name: '南京市', parent_id: province.id
      suburb1 = create :suburb, name: "浦口区", parent_id: city.id
      suburb2 = create :suburb, name: "秦淮区", parent_id: city.id
      post = build :takehouse, user: (create :wechat_user, gender: 'female')
      post.location = build :location, city: city, suburb: suburb1, province: province
      post.save

      post = build :takehouse
      post.location = build :location, city: city, suburb: suburb2, province: province
      post.save

      get "/v1/posts", params: {filters: {gender: "female"}}, headers: @headers
      expect(response).to be_successful
      posts = JSON.load(response.body)["posts"]
      expect(posts.count).to eq 1
    end

    it 'should filter posts type' do
      get "/v1/posts", params: {filters: {type: 'takehouse'}}, headers: @headers
      expect(response).to be_successful
      posts = JSON.load(response.body)["posts"]
      expect(posts.count).to eq 4
    end

    it 'should filter posts type' do
      get "/v1/posts", params: {filters: {type: 'sharehouse'}}, headers: @headers
      expect(response).to be_successful
      posts = JSON.load(response.body)["posts"]
      expect(posts.count).to eq 4
    end

    it 'should filter posts type' do
      get "/v1/posts", params: {filters: {type: 'housemate'}}, headers: @headers
      expect(response).to be_successful
      posts = JSON.load(response.body)["posts"]
      expect(posts.count).to eq 4
    end

    it 'should filter condition' do
      country  = create :country, name: "中国"
      province = create :province, name: '江苏省', parent_id: country.id
      city = create :city, name: '南京市', parent_id: province.id
      suburb1 = create :suburb, name: "浦口区", parent_id: city.id
      suburb2 = create :suburb, name: "秦淮区", parent_id: city.id
      post = build :takehouse, user: (create :wechat_user, gender: 'female'), has_appliance: true, has_furniture: false, has_cook_top: true
      post.location = build :location, city: city, suburb: suburb1, province: province
      post.save

      post = build :takehouse, user: (create :wechat_user, gender: 'female'), has_appliance: true, has_furniture: true, has_cook_top: false
      post.location = build :location, city: city, suburb: suburb1, province: province
      post.save

      post = build :takehouse, user: (create :wechat_user, gender: 'female'), has_appliance: true, has_furniture: true, has_cook_top: true
      post.location = build :location, city: city, suburb: suburb1, province: province
      post.save

      get "/v1/posts", params: {filters: {has_furniture: true, has_cook_top: true, has_appliance: true}}, headers: @headers
      expect(response).to be_successful
      posts = JSON.load(response.body)["posts"]
      expect(posts.count).to eq 1

      get "/v1/posts", params: {filters: {has_furniture: true, has_cook_top: true, has_appliance: false}}, headers: @headers
      expect(response).to be_successful
      posts = JSON.load(response.body)["posts"]
      expect(posts.count).to eq 0

      get "/v1/posts", params: {filters: {has_furniture: true, has_cook_top: false, has_appliance: true}}, headers: @headers
      expect(response).to be_successful
      posts = JSON.load(response.body)["posts"]
      expect(posts.count).to eq 1

      get "/v1/posts", params: {filters: {has_furniture: true}}, headers: @headers
      expect(response).to be_successful
      posts = JSON.load(response.body)["posts"]
      expect(posts.count).to eq 2
    end

  end


  describe "create" do

  end
end
