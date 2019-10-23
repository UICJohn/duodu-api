require 'rails_helper'

RSpec.describe Post, type: :model do

  describe '#create' do
    before do
      @post = create :housemate
    end

    it 'should create location' do
      expect{
        create :location, target: @post
      }.to change(Location, :count).by(1)
    end

    it 'should create location' do
      location = build :location, address: '南二环', longitude: nil, target: @post
      expect(location.valid?).to eq true
    end

    it 'should not create location if key fields missing' do
      location = build :location, address: nil, longitude: nil, target: @post
      expect(location.valid?).to eq false
      expect(location.errors.full_messages).to eq ["key fields missing"]
    end

    it 'should not create location if key fields missing' do
      location = build :location, address: nil, latitude: nil, target: @post
      expect(location.valid?).to eq false
      expect(location.errors.full_messages).to eq ["key fields missing"]
    end

  end

  describe '#fetch_location_detail' do
    before do
      @post = create :housemate
      @country = create :country
      @province = create :province, name: '北京市', country: @country
      @city = create :city, name: '北京市', province: @province
      @suburb = create :suburb, name: '门头沟区', city: @city
    end

    it 'should run fetch_location_detail worker | reverse: true' do
      allow(Map).to receive(:reverse_geocode).and_return({"location"=>{"lat"=>39.912391, "lng"=>116.125863}, "address"=>"北京市门头沟区石龙东路", "formatted_addresses"=>{"recommend"=>"门头沟新城", "rough"=>"门头沟新城"}, "address_component"=>{"nation"=>"中国", "province"=>"北京市", "city"=>"北京市", "district"=>"门头沟区", "street"=>"石龙东路", "street_number"=>"石龙东路"}, "ad_info"=>{"nation_code"=>"156", "adcode"=>"110109", "city_code"=>"156110000", "name"=>"中国,北京市,北京市,门头沟区", "location"=>{"lat"=>39.912392, "lng"=>116.125862}, "nation"=>"中国", "province"=>"北京市", "city"=>"北京市", "district"=>"门头沟区"}, "address_reference"=>{"street_number"=>{"id"=>"", "title"=>"", "location"=>{"lat"=>39.911915, "lng"=>116.126083}, "_distance"=>49.6, "_dir_desc"=>"北"}, "business_area"=>{"id"=>"5808235588535804078", "title"=>"永定", "location"=>{"lat"=>39.912392, "lng"=>116.125862}, "_distance"=>0, "_dir_desc"=>"内"}, "famous_area"=>{"id"=>"5808235588535804078", "title"=>"永定", "location"=>{"lat"=>39.912392, "lng"=>116.125862}, "_distance"=>0, "_dir_desc"=>"内"}, "town"=>{"id"=>"110109006", "title"=>"永定镇", "location"=>{"lat"=>39.912392, "lng"=>116.125862}, "_distance"=>0, "_dir_desc"=>"内"}, "street"=>{"id"=>"13694683111035560626", "title"=>"石龙东路", "location"=>{"lat"=>39.911915, "lng"=>116.126083}, "_distance"=>49.6, "_dir_desc"=>"北"}, "landmark_l2"=>{"id"=>"5134902804537691571", "title"=>"门头沟新城", "location"=>{"lat"=>39.909653, "lng"=>116.125175}, "_distance"=>310.5, "_dir_desc"=>"北"}}})
      Sidekiq::Testing.inline! do
        location = create(:location, target: @post)
        @post.locations << location
        location.reload   
        expect(location.country_id).to eq @country.id
        expect(location.province_id).to eq @province.id
        expect(location.city_id).to eq @city.id
        expect(location.suburb_id).to eq @suburb.id
        expect(location.address).to eq "北京市门头沟区石龙东路"
      end
    end

    it 'should run fetch_location_detail worker | reverse: false' do
      allow(Map).to receive(:geocode).and_return({"title"=>"南二环西段69号", "location"=>{"lng"=>108.93425, "lat"=>34.23052}, "ad_info"=>{"adcode"=>"610103"}, "address_components"=>{"province"=>"陕西省", "city"=>"西安市", "district"=>"碑林区", "street"=>"南二环西段", "street_number"=>"69"}, "similarity"=>0.8, "deviation"=>1000, "reliability"=>7, "level"=>9})
      Sidekiq::Testing.inline! do
        location = create(:location, target: @post, address: '北二环22号', longitude: nil, latitude: nil)
        @post.locations << location
        location.reload   
        expect(location.longitude.to_f).to eq 108.93425
        expect(location.latitude.to_f).to eq 34.23052
      end
    end
  end

  describe '#suburb_id=' do
    before do
      @country = create :country
      @province = create :province, country: @country
      @city = create :city, province: @province
      @suburb = create :suburb, city: @city
    end

    it 'should set all regions' do
      post = create :takehouse
      location = create :location, country_id: nil, province_id: nil, city_id: nil, suburb_id: nil, target: post
      expect{
        location.suburb_id = @suburb.id
      }.not_to raise_error
      expect(location.suburb).to eq @suburb
      expect(location.city).to eq @city
      expect(location.province).to eq @province
      expect(location.country).to eq @country
    end
  end

  describe '#city_id=' do
    before do
      @country = create :country
      @province = create :province, country: @country
      @city = create :city, province: @province
      @suburb = create :suburb, city: @city
    end

    it 'should set all regions' do
      post = create :takehouse
      location = create :location, country_id: nil, province_id: nil, city_id: nil, suburb_id: nil, target: post
      expect{
        location.city_id = @city.id
      }.not_to raise_error
      expect(location.suburb).to eq nil
      expect(location.city).to eq @city
      expect(location.province).to eq @province
      expect(location.country).to eq @country
    end
  end

  describe '#country_id=' do
    before do
      @country = create :country
      @province = create :province, country: @country
      @city = create :city, province: @province
      @suburb = create :suburb, city: @city
    end

    it 'should set all regions' do
      post = create :takehouse
      location = create :location, country_id: nil, province_id: nil, city_id: nil, suburb_id: nil, target: post
      expect{
        location.country_id = @country.id
      }.not_to raise_error
      expect(location.suburb).to eq nil
      expect(location.city).to eq nil
      expect(location.province).to eq nil
      expect(location.country).to eq @country
    end
  end

  describe '#province_id=' do
    before do
      @country = create :country
      @province = create :province, country: @country
      @city = create :city, province: @province
      @suburb = create :suburb, city: @city
    end

    it 'should set all regions' do
      post = create :takehouse
      location = create :location, country_id: nil, province_id: nil, city_id: nil, suburb_id: nil, target: post
      expect{
        location.province_id = @province.id
      }.not_to raise_error
      expect(location.suburb).to eq nil
      expect(location.city).to eq nil
      expect(location.province).to eq @province
      expect(location.country).to eq @country
    end
  end

  describe '#update' do
    before do
      @country = create :country
      @province = create :province, country: @country
      @city = create :city, province: @province
      @suburb = create :suburb, city: @city
    end

    it 'should set all regions' do
      post = create :takehouse
      location = create :location, country_id: nil, province_id: nil, city_id: nil, suburb_id: nil, target: post
      expect{
        location.update(suburb_id: @suburb.id)
      }.not_to raise_error
      expect(location.suburb).to eq @suburb
      expect(location.city).to eq @city
      expect(location.province).to eq @province
      expect(location.country).to eq @country
    end
  end

end
