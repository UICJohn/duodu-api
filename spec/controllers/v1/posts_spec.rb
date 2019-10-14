require 'rails_helper'
require 'devise/jwt/test_helpers'

RSpec.describe 'Post', type: :request do

  describe 'index' do
    before do
      @user = create :wechat_user
      @headers = Devise::JWT::TestHelpers.auth_headers({ 'Accept' => 'application/json' }, @user)
    end

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
    before do
      @user = create :wechat_user
      @headers = Devise::JWT::TestHelpers.auth_headers({ 'Accept' => 'application/json' }, @user)
    end

    it 'should not create house posts if not authencatied' do
      expect{
        post "/v1/posts", params: { post: {
          post_type: 'take_house',
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

    it 'should crete take house posts' do
      expect{
        post "/v1/posts", params: { post: {
          title: "asdfasf",
          body: "asdfasdf",
          rent: "2000",
          rooms: "2",
          livings: "2",
          toilets: "1",
          property_type: "house",
          payment_type: "0",
          available_from: "2019-10-12",
          location_attributes: {
            name: "西安市发改委",
            address: "陕西省西安市未央区凤城八路",
            longitude: 108.93984,
            latitude: 34.34127
          },
          post_type: "take_house",
          has_air_conditioner: false,
          has_furniture: false,
          has_elevator: false,
          has_cook_top: false,
          has_appliance: false,
          has_network: false,
        }}, headers: @headers
      }.to change(Post::TakeHouse, :count).by 1
      expect(response).to be_successful
      post = JSON.parse response.body
      expect(post["post"]).to be_present
      expect(Post::TakeHouse.first.active?).to eq false
    end
  end

  describe "#upload_images" do

    before do
      @user = create :wechat_user
      @headers = Devise::JWT::TestHelpers.auth_headers({ 'Accept' => 'application/json' }, @user)
    end

    it 'should update image' do
      post = create :takehouse, user_id: @user.id
      put "/v1/posts/#{post.id}/upload_images", params: {
        attachment: fixture_file_upload(Rails.root.join('spec', 'fixtures', 'assets', 'test.jpg'), 'image/jpg')
      }, headers: @headers
      post.reload
      expect(post.attachments).to be_present
      expect(post.active?).to eq true
    end

    it 'should not update image' do
      post = create :takehouse, user_id: (create :wechat_user).id
      put "/v1/posts/#{post.id}/upload_images", params: {
        attachment: fixture_file_upload(Rails.root.join('spec', 'fixtures', 'assets', 'test.jpg'), 'image/jpg')
      }, headers: @headers
      post.reload
      expect(post.attachments).not_to be_present
      expect(post.active?).to eq false
    end

    it 'should not update image' do
      post = create :takehouse, user_id: @user.id
      put "/v1/posts/#{post.id}/upload_images", params: {
        attachment: fixture_file_upload(Rails.root.join('spec', 'fixtures', 'assets', 'test.txt'), 'text/plain')
      }, headers: @headers
      post.reload
      expect(post.attachments).not_to be_present
      expect(post.active?).to eq false
    end
  end
end
