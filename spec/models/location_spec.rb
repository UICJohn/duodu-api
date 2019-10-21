require 'rails_helper'

RSpec.describe Post, type: :model do
  describe '#suburb_id=' do
    before do
      @country = create :country
      @province = create :province, country: @country
      @city = create :city, province: @province
      @suburb = create :suburb, city: @city
    end

    it 'should set all regions' do
      post = create :takehouse
      location = create :location, target: post
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
      location = create :location, target: post
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
      location = create :location, target: post
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
      location = create :location, target: post
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
      location = create :location, target: post
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
