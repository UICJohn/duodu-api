require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'from_wechat' do
    it 'should not create duplicate user with same uid' do
      expect {
        User.from_wechat({uid: 'absafasdfiowef', session: 'safawefwf1412'})
      }.to change(User, :count).by 1

      expect {
        User.from_wechat({uid: 'absafasdfiowef', session: 'safawefwf1412'})
      }.to change(User, :count).by 0
    end
  end
end
