require 'rails_helper'
require 'devise/jwt/test_helpers'

RSpec.describe 'Post', type: :request do
  before do
    @user = create :wechat_user
    @headers = Devise::JWT::TestHelpers.auth_headers({ 'Accept' => 'application/json' }, @user)    
  end

  describe 'index' do

    before do
      cities = %w(深圳市 惠州市 广州市).map{ |name| create :city, name: name }
      suburbs = %w(南山区 龙岗区).map{ |name| create :suburb, name: name }
      4.times { create :takehouse }
      4.times { create :sharehouse }
      4.times { create :housemate, area_ids: suburbs.map(&:id) }
    end

    it 'should success' do
      get '/v1/posts', params: {}, headers: @headers
      expect(response).to be_successful
      posts = JSON.parse(response.body)['posts']
      expect(posts.count).to eq 10
    end

    it 'should success' do
      get '/v1/posts', params: { page: 2 }, headers: @headers
      expect(response).to be_successful
      posts = JSON.parse(response.body)['posts']
      expect(posts.count).to eq 2
    end

    # it 'should filter posts with location' do
    #   country  = create :country, name: '中国'
    #   province = create :province, name: '江苏省', parent_id: country.id
    #   city = create :city, name: '南京市', parent_id: province.id
    #   suburb = create :suburb, name: '浦口区', parent_id: city.id
    #   post = build :takehouse
    #   post.location = build :location, city: city, suburb: suburb, province: province
    #   post.save

    #   get '/v1/posts', params: { filters: { city: '南京市' } }, headers: @headers
    #   expect(response).to be_successful
    #   posts = JSON.parse(response.body)['posts']
    #   expect(posts.count).to eq 1
    # end

    # it 'should filter posts with location' do
    #   country  = create :country, name: '中国'
    #   province = create :province, name: '江苏省', parent_id: country.id
    #   city = create :city, name: '南京市', parent_id: province.id
    #   suburb = create :suburb, name: '浦口区', parent_id: city.id
    #   post = build :takehouse
    #   post.location = build :location, city: city, suburb: suburb, province: province
    #   post.save

    #   get '/v1/posts', params: { filters: { city: '南京市' } }, headers: @headers
    #   expect(response).to be_successful
    #   posts = JSON.parse(response.body)['posts']
    #   expect(posts.count).to eq 1
    # end

    # it 'should filter posts with location' do
    #   country  = create :country, name: '中国'
    #   province = create :province, name: '江苏省', parent_id: country.id
    #   city = create :city, name: '南京市', parent_id: province.id
    #   suburb = create :suburb, name: '浦口区', parent_id: city.id
    #   suburb1 = create :suburb, name: '秦淮区', parent_id: city.id
    #   post = build :takehouse
    #   post.location = build :location, city: city, suburb: suburb, province: province
    #   post.save

    #   post = build :takehouse
    #   post.location = build :location, city: city, suburb: suburb1, province: province
    #   post.save

    #   get '/v1/posts', params: { filters: { city: '南京市' } }, headers: @headers
    #   expect(response).to be_successful
    #   posts = JSON.parse(response.body)['posts']
    #   expect(posts.count).to eq 2
    # end

    # it 'should filter posts with location' do
    #   country  = create :country, name: '中国'
    #   province = create :province, name: '江苏省', parent_id: country.id
    #   city = create :city, name: '南京市', parent_id: province.id
    #   suburb1 = create :suburb, name: '浦口区', parent_id: city.id
    #   suburb2 = create :suburb, name: '秦淮区', parent_id: city.id
    #   post = build :takehouse
    #   post.location = build :location, city: city, suburb: suburb1, province: province
    #   post.save

    #   post = build :takehouse
    #   post.location = build :location, city: city, suburb: suburb2, province: province
    #   post.save

    #   get '/v1/posts', params: { filters: { suburb: '浦口区' } }, headers: @headers
    #   expect(response).to be_successful
    #   posts = JSON.parse(response.body)['posts']
    #   expect(posts.count).to eq 1
    # end

    # it 'should filter user gender' do
    #   country  = create :country, name: '中国'
    #   province = create :province, name: '江苏省', parent_id: country.id
    #   city = create :city, name: '南京市', parent_id: province.id
    #   suburb1 = create :suburb, name: '浦口区', parent_id: city.id
    #   suburb2 = create :suburb, name: '秦淮区', parent_id: city.id
    #   post = build :takehouse, user: (create :wechat_user, gender: 'female')
    #   post.location = build :location, city: city, suburb: suburb1, province: province
    #   post.save

    #   post = build :takehouse
    #   post.location = build :location, city: city, suburb: suburb2, province: province
    #   post.save

    #   get '/v1/posts', params: { filters: { gender: 'female' } }, headers: @headers
    #   expect(response).to be_successful
    #   posts = JSON.parse(response.body)['posts']
    #   expect(posts.count).to eq 1
    # end

    # it 'should filter posts type' do
    #   get '/v1/posts', params: { filters: { type: 'takehouse' } }, headers: @headers
    #   expect(response).to be_successful
    #   posts = JSON.parse(response.body)['posts']
    #   expect(posts.count).to eq 4
    # end

    # it 'should filter posts type' do
    #   get '/v1/posts', params: { filters: { type: 'sharehouse' } }, headers: @headers
    #   expect(response).to be_successful
    #   posts = JSON.parse(response.body)['posts']
    #   expect(posts.count).to eq 4
    # end

    # it 'should filter posts type' do
    #   get '/v1/posts', params: { filters: { type: 'housemate' } }, headers: @headers
    #   expect(response).to be_successful
    #   posts = JSON.parse(response.body)['posts']
    #   expect(posts.count).to eq 4
    # end

    # it 'should filter condition' do
    #   create :takehouse, user: (create :wechat_user, gender: 'female'), has_appliance: true, has_furniture: false, has_cook_top: true
    #   create :takehouse, user: (create :wechat_user, gender: 'male'), has_appliance: true, has_furniture: true, has_cook_top: false
    #   create :takehouse, user: (create :wechat_user, gender: 'female'), has_appliance: true, has_furniture: true, has_cook_top: true

    #   get '/v1/posts', params: { filters: { has_furniture: true, has_cook_top: true, has_appliance: true } }, headers: @headers
    #   expect(response).to be_successful
    #   posts = JSON.parse(response.body)['posts']
    #   expect(posts.count).to eq 1

    #   get '/v1/posts', params: { filters: { has_furniture: true, has_cook_top: true, has_appliance: false } }, headers: @headers
    #   expect(response).to be_successful
    #   posts = JSON.parse(response.body)['posts']
    #   expect(posts.count).to eq 0

    #   get '/v1/posts', params: { filters: { has_furniture: true, has_cook_top: false, has_appliance: true } }, headers: @headers
    #   expect(response).to be_successful
    #   posts = JSON.parse(response.body)['posts']
    #   expect(posts.count).to eq 1

    #   get '/v1/posts', params: { filters: { has_furniture: true } }, headers: @headers
    #   expect(response).to be_successful
    #   posts = JSON.parse(response.body)['posts']
    #   expect(posts.count).to eq 2
    # end

    # it 'should filter livings' do
    #   create :takehouse, user: (create :wechat_user, gender: 'female'), livings: 1, rooms: 2, toilets: 2
    #   create :takehouse, user: (create :wechat_user, gender: 'male'), livings: 2, rooms: 2, toilets: 1
    #   create :sharehouse, user: (create :wechat_user, gender: 'female'), livings: 2, rooms: 3, toilets: 2
    #   get '/v1/posts', params: { filters: { livings: [2] } }, headers: @headers

    #   expect(response).to be_successful
    #   posts = JSON.parse(response.body)['posts']
    #   expect(posts.count).to eq 2

    #   get '/v1/posts', params: { filters: { livings: [1, 2] } }, headers: @headers

    #   expect(response).to be_successful
    #   posts = JSON.parse(response.body)['posts']
    #   expect(posts.count).to eq 3

    #   get '/v1/posts', params: { filters: { livings: [3] } }, headers: @headers

    #   expect(response).to be_successful
    #   posts = JSON.parse(response.body)['posts']
    #   expect(posts.count).to eq 0
    # end

    # it 'should filter rooms' do
    #   create :takehouse, user: (create :wechat_user, gender: 'female'), livings: 1, rooms: 2, toilets: 2
    #   create :takehouse, user: (create :wechat_user, gender: 'male'), livings: 2, rooms: 2, toilets: 1
    #   create :sharehouse, user: (create :wechat_user, gender: 'female'), livings: 2, rooms: 3, toilets: 2

    #   get '/v1/posts', params: { filters: { rooms: [2] } }, headers: @headers
    #   expect(response).to be_successful
    #   posts = JSON.parse(response.body)['posts']
    #   expect(posts.count).to eq 2

    #   get '/v1/posts', params: { filters: { rooms: [3] } }, headers: @headers
    #   expect(response).to be_successful
    #   posts = JSON.parse(response.body)['posts']
    #   expect(posts.count).to eq 1

    #   get '/v1/posts', params: { filters: { rooms: [1, 3] } }, headers: @headers
    #   expect(response).to be_successful
    #   posts = JSON.parse(response.body)['posts']
    #   expect(posts.count).to eq 2

    #   get '/v1/posts', params: { filters: { rooms: [4, 3] } }, headers: @headers
    #   expect(response).to be_successful
    #   posts = JSON.parse(response.body)['posts']
    #   expect(posts.count).to eq 1
    # end

    # it 'should filter toilets' do
    #   create :takehouse, user: (create :wechat_user, gender: 'female'), livings: 1, rooms: 2, toilets: 2
    #   create :takehouse, user: (create :wechat_user, gender: 'male'), livings: 2, rooms: 2, toilets: 1
    #   create :sharehouse, user: (create :wechat_user, gender: 'female'), livings: 2, rooms: 3, toilets: 2

    #   get '/v1/posts', params: { filters: { toilets: [2] } }, headers: @headers
    #   expect(response).to be_successful
    #   posts = JSON.parse(response.body)['posts']
    #   expect(posts.count).to eq 2

    #   get '/v1/posts', params: { filters: { toilets: [3] } }, headers: @headers
    #   expect(response).to be_successful
    #   posts = JSON.parse(response.body)['posts']
    #   expect(posts.count).to eq 0

    #   get '/v1/posts', params: { filters: { toilets: [1, 3] } }, headers: @headers
    #   expect(response).to be_successful
    #   posts = JSON.parse(response.body)['posts']
    #   expect(posts.count).to eq 1
    # end
  end

  describe 'create' do
    it 'should not create house posts if not authencatied' do
      expect{
        post "/v1/posts", params: { posts: {
          post_type: 0,
          title: 'blablabla',
          body: 'blablabla',
          rooms: 1,
          rent: 200,
          tenants: 2,
          livings: 3,
          toilets: 2,
          payment_type: 0,
          available_from: '2019-01-01',
          has_furniture: 'true',
          has_appliance: 'true',
          has_network: 'true',
          has_air_conditioner: 'true',
          has_elevator: 'true',
          has_cook_top: 'false',
          pets_allow: 'false',
          smoke_allow: 'false',
          tenants_gender: 'false',
          location_attributes: {
            longitude: 120.00,
            latitude: 89.21,
            address: 'google大厦'
          }
        }}
      }.to change(Post::Base, :count).by 0
      expect(response).not_to be_successful
    end

    it 'should return bad request error' do

    end
  end
end
