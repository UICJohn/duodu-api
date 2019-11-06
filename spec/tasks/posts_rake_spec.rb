require 'rails_helper'
require 'rake'
load File.join(Rails.root, 'lib', 'tasks', 'posts.rake')

describe 'posts:activate' do
  before do
    @country = create :country
    @province = create :province, name: '北京市', country: @country
    @city = create :city, name: '北京市', province: @province
    @suburb = create :suburb, name: '门头沟区', city: @city
  end
  it "should activate posts" do
    4.times { create :housemate }
    take = create :takehouse
    take2 = create :takehouse
    share = create :sharehouse
    share2 = create :sharehouse
    take.images.attach(fixture_file_upload(Rails.root.join('spec', 'fixtures', 'assets', 'test.jpg'), 'image/jpg'))
    share.images.attach(fixture_file_upload(Rails.root.join('spec', 'fixtures', 'assets', 'test.jpg'), 'image/jpg'))
    Rake::Task['posts:activate'].execute
    expect(Post::Base.active.count).to eq 6
    expect(Post::Base.where(active: false).count).to eq 2
  end
end
