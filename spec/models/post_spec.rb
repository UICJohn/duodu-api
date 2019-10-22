require 'rails_helper'

RSpec.describe Post, type: :model do

  describe "create" do
    it 'should not create take house' do
      post = Post::TakeHouse.create(
        title: 'blabla',
        body: 'blabla',
      )
      expect(post.persisted?).to eq false
      expect(post.errors.messages.map{ |k, v| k}).to eq [
        :user,
        :available_from,
        :rent,
        :location,
        :payment_type,
        :livings,
        :toilets, 
        :rooms,
        :property_type
      ]
    end

    it 'should not create share house' do
      post = Post::ShareHouse.create(
        title: 'blabla',
        body: 'blabla',
      )
      expect(post.persisted?).to eq false
      expect(post.errors.messages.map{ |k, v| k}).to eq [
        :user,
        :available_from,
        :rent,
        :location,
        :payment_type,
        :livings,
        :toilets,
        :rooms,
        :property_type,
        :tenants
      ]
    end

    it 'should not create house mate post' do
      post = Post::HouseMate.create(
        title: 'blabla',
        body: 'blabla',
      )
      expect(post.persisted?).to eq false
      expect(post.errors.messages.map{ |k, v| k}).to eq [
        :user,
        :available_from,
        :locations
      ]
    end
  end

  describe "images" do
    it 'should not upload more than 8 images' do
      post = create :takehouse
      (0...9).each { post.images.attach(fixture_file_upload(Rails.root.join('spec', 'fixtures', 'assets', 'test.jpg'), 'image/jpg')) }
      expect(post.valid?).to eq false
      expect(post.images_blobs.count).to eq 8
    end

    it 'should not upload more than 8 images' do
      post = create :sharehouse
      (0...9).each { post.images.attach(fixture_file_upload(Rails.root.join('spec', 'fixtures', 'assets', 'test.jpg'), 'image/jpg')) }
      expect(post.valid?).to eq false
      expect(post.images_blobs.count).to eq 8
    end
  end

  describe "can_active?" do
    it 'should not able to be actived' do
      post = create :takehouse
      post.update(active: true)
      expect(post.valid?).to eq false
    end

    it 'should able to be active' do
      post = create :takehouse
      post.images.attach(fixture_file_upload(Rails.root.join('spec', 'fixtures', 'assets', 'test.jpg'), 'image/jpg'))
      post.update(active: true)
      expect(post.valid?).to eq true
    end

    it 'should not able to be actived' do
      post = create :sharehouse
      post.update(active: true)
      expect(post.valid?).to eq false
    end

    it 'should able to be active' do
      post = create :sharehouse
      post.images.attach(fixture_file_upload(Rails.root.join('spec', 'fixtures', 'assets', 'test.jpg'), 'image/jpg'))
      post.update(active: true)
      expect(post.valid?).to be true
    end
  end

  describe "set_type" do
    before do
      @user = create :wechat_user
      @suburbs = %w(南山区 龙岗区).map{ |name| create :suburb, name: name }
    end

    it 'should set posts type to Post::TakeHouse' do
      expect{
        Post::Base.create!(
          user: @user,
          title: 'blablabla',
          body: 'blablabla',
          available_from: '2019-09-12',
          livings: 2,
          rooms: 2,
          toilets: 1,
          post_type: 'take_house'
        )
      }.to change(Post::TakeHouse, :count).by(1)
    end

    it 'should set posts type to Post::ShareHouse' do
      expect{
        Post::Base.create!(
          user: @user,
          title: 'blablabla',
          body: 'blablabla',
          available_from: '2019-09-12',
          livings: 2,
          rooms: 2,
          toilets: 1,
          tenants: 1,
          post_type: 'share_house'
        )
      }.to change(Post::ShareHouse, :count).by(1)
    end

    it 'should set posts type to Post::HouseMate' do
      expect{
        Post::Base.create!(
          user: @user,
          title: 'blablabla',
          body: 'blablabla',
          available_from: '2019-09-12',
          area_ids: @suburbs.map(&:id),
          post_type: 'house_mate'
        )
      }.to change(Post::HouseMate, :count).by(1)
    end
  end
end