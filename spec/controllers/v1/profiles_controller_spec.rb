require 'rails_helper'

RSpec.describe V1::PorfilesController, type: :controller do
  describe '#update' do
    user = create :user
    put :update, params: {intro: 'introduction', city: 'xian', country: 'CN', province: 'shanxi', suburb: 'xincheng',  gender: 'male', occupation: 'programmer'}


  end
end
