require 'rails_helper'

RSpec.describe LocationDetailWorker, type: :model do

  describe '#perform' do
    before do
      @post = create :housemate
      @country = create :country
      @province = create :province, name: '北京市', country: @country
      @city = create :city, name: '北京市', province: @province
      @suburb = create :suburb, name: '门头沟区', city: @city
    end

    it 'should run fetch_location_detail worker' do
      allow(Map).to receive(:reverse_geocode).and_return({"location"=>{"lat"=>39.912391, "lng"=>116.125863}, "address"=>"北京市门头沟区石龙东路", "formatted_addresses"=>{"recommend"=>"门头沟新城", "rough"=>"门头沟新城"}, "address_component"=>{"nation"=>"中国", "province"=>"北京市", "city"=>"北京市", "district"=>"门头沟区", "street"=>"石龙东路", "street_number"=>"石龙东路"}, "ad_info"=>{"nation_code"=>"156", "adcode"=>"110109", "city_code"=>"156110000", "name"=>"中国,北京市,北京市,门头沟区", "location"=>{"lat"=>39.912392, "lng"=>116.125862}, "nation"=>"中国", "province"=>"北京市", "city"=>"北京市", "district"=>"门头沟区"}, "address_reference"=>{"street_number"=>{"id"=>"", "title"=>"", "location"=>{"lat"=>39.911915, "lng"=>116.126083}, "_distance"=>49.6, "_dir_desc"=>"北"}, "business_area"=>{"id"=>"5808235588535804078", "title"=>"永定", "location"=>{"lat"=>39.912392, "lng"=>116.125862}, "_distance"=>0, "_dir_desc"=>"内"}, "famous_area"=>{"id"=>"5808235588535804078", "title"=>"永定", "location"=>{"lat"=>39.912392, "lng"=>116.125862}, "_distance"=>0, "_dir_desc"=>"内"}, "town"=>{"id"=>"110109006", "title"=>"永定镇", "location"=>{"lat"=>39.912392, "lng"=>116.125862}, "_distance"=>0, "_dir_desc"=>"内"}, "street"=>{"id"=>"13694683111035560626", "title"=>"石龙东路", "location"=>{"lat"=>39.911915, "lng"=>116.126083}, "_distance"=>49.6, "_dir_desc"=>"北"}, "landmark_l2"=>{"id"=>"5134902804537691571", "title"=>"门头沟新城", "location"=>{"lat"=>39.909653, "lng"=>116.125175}, "_distance"=>310.5, "_dir_desc"=>"北"}}})
      Sidekiq::Testing.inline! do
        expect{
          location = create(:location, target: @post)
          LocationDetailWorker.new.perform(location.id, true)
        }.not_to raise_error
      end
    end
  end
end
