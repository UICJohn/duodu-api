require 'rails_helper'

RSpec.describe VerificationCode, type: :model do
  describe '#verified?' do
    it 'should return true' do
      code_service = VerificationCode.new('email' => 'john@gmail.com')
      allow_any_instance_of(VerificationCode).to receive(:generate_code).and_return('D-4560446')
      code_service.issue
      expect(VerificationCode.new('email' => 'john@gmail.com').verified?('D-4560446')).to eq true
    end

    it 'should return false' do
      code_service = VerificationCode.new('email' => 'john@gmail.com')
      allow_any_instance_of(VerificationCode).to receive(:generate_code).and_return('D-4560446')
      code_service.issue
      expect(VerificationCode.new('email' => 'john@gmail.com').verified?('D-4561246')).to eq false
    end
  end

  describe '#record_name' do
    it 'should return correct email key' do
      code_service = VerificationCode.new('email' => 'john@gmail.com')
      expect(code_service.send(:record_name)).to eq 'email_john@gmail.com'
    end

    it 'should return correct phone key' do
      code_service = VerificationCode.new('phone' => '17482830192')
      expect(code_service.send(:record_name)).to eq 'phone_17482830192'
    end
  end

  describe '#record_expired?' do
    before do
      @code_service = VerificationCode.new('phone' => '17482830192')
      @code_service.issue
    end

    it 'should return false' do
      expect(@code_service.send('record_expired?')).to eq false
    end

    it 'should return true' do
      allow(Time).to receive(:now).and_return 12.minutes.since
      expect(@code_service.send('record_expired?')).to eq true
    end

    it 'should return true' do
      code_service = VerificationCode.new('phone' => '18382830192')
      expect(code_service.send('record_expired?')).to eq true
    end

    describe '#fetch' do
      it 'should fetch correct record' do
        allow(Time).to receive(:now).and_return Time.zone.local(2019, 1, 1)
        allow_any_instance_of(VerificationCode).to receive(:generate_code).and_return('D-4560446')
        code_service = VerificationCode.new('phone' => '18382830192')
        code_service.issue
        expect(code_service.send('fetch')).to eq('code' => 'D-4560446', 'created_at' => JSON.parse(Time.zone.now.to_json))
      end

      it 'should not fetch record' do
        code_service = VerificationCode.new('phone' => '18382830192')
        expect(code_service.send('fetch')).to eq nil
      end
    end

    describe '#catch' do
      it 'should cache record' do
        allow_any_instance_of(VerificationCode).to receive(:generate_code).and_return('D-4560446')
        code_service = VerificationCode.new('phone' => '18382830192')
        code_service.send('cache', 'D-4560446')
        expect(code_service.send('fetch')).to include('code', 'created_at')
      end
    end
  end
end
