require 'rails_helper'

RSpec.describe Warehouse::DateDimension, type: :model do
  describe '#find_dimension_for' do
    it 'should create new date dimension' do
      expect{
        Warehouse::DateDimension.find_dimension_for(Time.now)
      }.to change(Warehouse::DateDimension, :count).by 1
    end

    it 'should find date dimension' do
      create :warehouse_date_dimension
      expect{
        Warehouse::DateDimension.find_dimension_for(Time.now)
      }.to change(Warehouse::DateDimension, :count).by 0
    end
  end
end
