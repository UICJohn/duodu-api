require 'rails_helper'
require 'devise/jwt/test_helpers'
require 'rake'
load File.join(Rails.root, 'lib', 'tasks', 'posts.rake')

RSpec.describe 'Post', type: :request do
  describe 'index' do
    before do
      @user = create :wechat_user
      @headers = Devise::JWT::TestHelpers.auth_headers({ 'Accept' => 'application/json' }, @user)
    end

    it 'should success' do
      4.times do
        post = create :takehouse
        post.images.attach(fixture_file_upload(Rails.root.join('spec', 'fixtures', 'assets', 'test.jpg'), 'image/jpg'))
      end
      4.times do
        post = create :sharehouse
        post.images.attach(fixture_file_upload(Rails.root.join('spec', 'fixtures', 'assets', 'test.jpg'), 'image/jpg'))
      end
      4.times { create :housemate }
      create :takehouse
      create :sharehouse

      Rake::Task['posts:activate'].execute
      get '/v1/posts', params: {}, headers: @headers
      expect(response).to be_successful
      posts = JSON.parse(response.body)['posts']
      expect(posts.count).to eq 10
    end

    it 'should success' do
      4.times { create :takehouse }
      4.times { create :sharehouse }
      4.times { create :housemate }

      get '/v1/posts', params: { page: 2 }, headers: @headers
      expect(response).to be_successful
      posts = JSON.parse(response.body)['posts']
      expect(posts.count).to eq 0
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
      expect do
        post '/v1/posts', params: { post: {
          type: 'take_house',
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
        } }
      end.to change(Post::Base, :count).by 0
      expect(response).not_to be_successful
    end

    it 'should crete take house posts' do
      expect do
        post '/v1/posts', params: { post: {
          title: 'asdfasf',
          body: 'asdfasdf',
          rent: '2000',
          rooms: '2',
          livings: '2',
          toilets: '1',
          property_type: 'house',
          payment_type: '0',
          available_from: '2019-10-12',
          type: 'take_house',
          location_attributes: {
            name: '西安市发改委',
                                  address: '陕西省西安市未央区凤城八路',
                                  longitude: 108.93984,
                                  latitude: 34.34127
          },
          has_air_conditioner: false,
          has_furniture: false,
          has_elevator: false,
          has_cook_top: false,
          has_appliance: false,
          has_network: false
        } }, headers: @headers
      end.to change(Post::TakeHouse, :count).by 1
      expect(response).to be_successful
      post = JSON.parse response.body
      expect(post['post']).to be_present
      expect(Post::TakeHouse.first.active?).to eq false
    end

    it 'should create house mate post' do
      expect do
        post '/v1/posts', params: {
          post: {
            title: 'sdfsf',
                  body: 'sdfsdfd',
                  locations_attributes: [
                    {
                      name: '腾讯众创空间(西安)',
                                            address: '陕西省西安市碑林区南二环西段69号西安创新设计中心',
                                            longitude: 108.93462,
                                            latitude: 34.23055
                    },
                    {
                      name: '腾讯众创空间(西安)',
                      address: '陕西省西安市碑林区南二环西段69号西安创新设计中心',
                      longitude: 108.93462,
                      latitude: 34.23055
                    },
                    {
                      name: '西安绥德商会',
                      address: '陕西省西安市未央区风景御园18号楼',
                      longitude: 108.939588,
                      latitude: 34.340366
                    }
                  ],
                  available_from: '2019-10-23',
                  min_rent: nil,
                  max_rent: nil,
                  range: nil,
                  type: 'house_mate',
                  tenants: nil,
                  has_air_conditioner: false,
                  has_furniture: false,
                  has_elevator: false,
                  has_cook_top: false,
                  has_appliance: false,
                  has_network: false
          }
        }, headers: @headers
      end.to change(Post::HouseMate, :count).by 1
      expect(response).to be_successful
      post = JSON.parse response.body
      expect(post['post']).to be_present
      housemate = Post::HouseMate.first
      expect(housemate.active?).to eq false
      expect(housemate.locations.count).to eq 3
    end

    it 'should not create house mate post if more than 4 locations' do
      expect do
        post '/v1/posts', params: {
          post: {
            title: 'sdfsf',
                  body: 'sdfsdfd',
                  type: 'house_mate',
                  locations_attributes: [
                    {
                      name: '腾讯众创空间(西安)',
                                            address: '陕西省西安市碑林区南二环西段69号西安创新设计中心',
                                            longitude: 108.93462,
                                            latitude: 34.23055
                    },
                    {
                      name: '腾讯众创空间(西安)',
                      address: '陕西省西安市碑林区南二环西段69号西安创新设计中心',
                      longitude: 108.93462,
                      latitude: 34.23055
                    },
                    {
                      name: '西安绥德商会',
                      address: '陕西省西安市未央区风景御园18号楼',
                      longitude: 108.939588,
                      latitude: 34.340366
                    },
                    {
                      name: '西安绥德商会',
                      address: '陕西省西安市未央区风景御园18号楼',
                      longitude: 108.919588,
                      latitude: 34.340366
                    },
                    {
                      name: '西安绥德商会',
                      address: '陕西省西安市未央区风景御园18号楼',
                      longitude: 108.929588,
                      latitude: 34.340366
                    }
                  ],
                  available_from: '2019-10-23',
                  min_rent: nil,
                  max_rent: nil,
                  range: nil,
                  post_type: 'house_mate',
                  tenants: nil,
                  has_air_conditioner: false,
                  has_furniture: false,
                  has_elevator: false,
                  has_cook_top: false,
                  has_appliance: false,
                  has_network: false
          }
        }, headers: @headers
      end.to change(Post::HouseMate, :count).by 0
      expect(response).to be_successful
      res = JSON.parse response.body
      expect(res['error'].key?('locations')).to eq true
    end

    it 'should not create house mate post if more than 4 locations' do
      expect do
        post '/v1/posts', params: {
          post: {
            title: 'sdfsf',
                  body: 'sdfsdfd',
                  locations_attributes: [],
                  available_from: '2019-10-23',
                  min_rent: nil,
                  max_rent: nil,
                  range: nil,
                  type: 'house_mate',
                  tenants: nil,
                  has_air_conditioner: false,
                  has_furniture: false,
                  has_elevator: false,
                  has_cook_top: false,
                  has_appliance: false,
                  has_network: false
          }
        }, headers: @headers
      end.to change(Post::HouseMate, :count).by 0
      expect(response).to be_successful
      res = JSON.parse response.body
      expect(res['error'].key?('locations')).to eq true
    end
  end

  describe '#upload_images' do
    before do
      @user = create :wechat_user
      @headers = Devise::JWT::TestHelpers.auth_headers({ 'Accept' => 'application/json' }, @user)
    end

    it 'should update image' do
      post = create :takehouse, user_id: @user.id
      post "/v1/posts/#{post.id}/upload_images", params: {
        attachment: fixture_file_upload(Rails.root.join('spec', 'fixtures', 'assets', 'test.jpg'), 'image/jpg')
      }, headers: @headers
      post.reload
      expect(post.images).to be_present
      expect(post.active?).to eq false
    end

    it 'should not update image' do
      post = create :takehouse, user_id: (create :wechat_user).id
      post "/v1/posts/#{post.id}/upload_images", params: {
        attachment: fixture_file_upload(Rails.root.join('spec', 'fixtures', 'assets', 'test.jpg'), 'image/jpg')
      }, headers: @headers
      post.reload
      expect(post.images).not_to be_present
      expect(post.active?).to eq false
    end

    it 'should not update image' do
      post = create :takehouse, user_id: @user.id
      post "/v1/posts/#{post.id}/upload_images", params: {
        attachment: fixture_file_upload(Rails.root.join('spec', 'fixtures', 'assets', 'test.txt'), 'text/plain')
      }, headers: @headers
      post.reload
      expect(post.images).not_to be_attached
      expect(post.active?).to eq false
    end

    it 'should not update image' do
      post = create :takehouse, user_id: @user.id
      8.times do
        post.images.attach(fixture_file_upload(Rails.root.join('spec', 'fixtures', 'assets', 'test.jpg'), 'image/jpg'))
      end
      post.reload
      post "/v1/posts/#{post.id}/upload_images", params: {
        attachment: fixture_file_upload(Rails.root.join('spec', 'fixtures', 'assets', 'test.jpg'), 'image/jpg')
      }, headers: @headers
      expect(post.images.attachments.count).to eq 8
      expect(post.active?).to eq false
    end
  end

  describe '#like' do
    before do
      @user = create :wechat_user
      @headers = Devise::JWT::TestHelpers.auth_headers({ 'Accept' => 'application/json' }, @user)
    end

    it 'should create post_collections for user' do
      posts = 4.times.map do
        post = create :takehouse
        post.images.attach(fixture_file_upload(Rails.root.join('spec', 'fixtures', 'assets', 'test.jpg'), 'image/jpg'))
        post
      end
      expect{
        post "/v1/posts/#{posts.first.id}/like", headers: @headers
      }.to change(PostCollection, :count).by 1
      expect(response).to be_successful
    end

    it 'should not create post_collections for user' do
      posts = 4.times.map do
        post = create :takehouse
        post.images.attach(fixture_file_upload(Rails.root.join('spec', 'fixtures', 'assets', 'test.jpg'), 'image/jpg'))
        post
      end
      PostCollection.create(post_id: posts.first.id, user_id: @user.id)
      expect{
        post "/v1/posts/#{posts.first.id}/like", headers: @headers
      }.to change(PostCollection, :count).by 0
      expect(response).to be_successful
    end

    it 'should response with error msg' do
      expect{
        post "/v1/posts/#{1}/like", headers: @headers
      }.to change(PostCollection, :count).by 0
      expect(response).to be_successful
      body = JSON.parse(response.body)
      expect(body).to eq({"error"=>"Post Not Found"})
    end

  end
end
