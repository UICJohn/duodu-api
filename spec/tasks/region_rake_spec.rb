require 'rails_helper'
require 'rake'
load File.join(Rails.root, 'lib', 'tasks', 'region.rake')

describe 'region:tasks' do
  before do
    Region::Country.create(code: 'CN', name: '中国')
  end
  it "should create region's baidu_id" do
    allow_any_instance_of(Map).to receive(:fetch_regions).and_return([
                                                                       [
                                                                         {
                                                                           'id' => '110000',
                                                                           'name' => '北京',
                                                                           'fullname' => '北京市',
                                                                           'pinyin' => %w[bei jing],
                                                                           'location' => { 'lat' => 39.90469, 'lng' => 116.40717 },
                                                                           'cidx' => [0, 1]
                                                                         },
                                                                         {
                                                                           'id' => '120000',
                                                                           'name' => '大连',
                                                                           'fullname' => '大连市',
                                                                           'pinyin' => %w[tian jin],
                                                                           'location' => { 'lat' => 39.0851, 'lng' => 117.19937 },
                                                                           'cidx' => [1, 2]
                                                                         }
                                                                       ],
                                                                       [
                                                                         {
                                                                           'id' => '120119',
                                                                           'name' => '蓟州',
                                                                           'fullname' => '蓟州区',
                                                                           'pinyin' => %w[ji zhou],
                                                                           'location' => { 'lat' => 40.04577, 'lng' => 117.40829 }
                                                                         },
                                                                         {
                                                                           'id' => '130200',
                                                                           'name' => '唐山',
                                                                           'fullname' => '唐山市',
                                                                           'pinyin' => %w[tang shan],
                                                                           'location' => { 'lat' => 39.63048, 'lng' => 118.18058 },
                                                                           'cidx' => [0, 1]
                                                                         }
                                                                       ],
                                                                       [
                                                                         {
                                                                           'id' => '469026',
                                                                           'name' => '昌江',
                                                                           'fullname' => '昌江黎族自治县',
                                                                           'pinyin' => %w[chang jiang],
                                                                           'location' => { 'lat' => 19.29828, 'lng' => 109.05559 }
                                                                         },
                                                                         {
                                                                           'id' => '469027',
                                                                           'name' => '乐东',
                                                                           'fullname' => '乐东黎族自治县',
                                                                           'pinyin' => %w[le dong],
                                                                           'location' => { 'lat' => 18.74986, 'lng' => 109.17361 }
                                                                         }
                                                                       ]
                                                                     ])
    Rake::Task['region:sync'].execute
    expect(Region::Province.count).to eq 2
    expect(Region::City.count).to eq 2
    expect(Region::Suburb.count).to eq 2
  end

  it 'should not create duplicate subways' do
    Region::Base.create(name: '北京市', baidu_id: 'adfajasdjflkaf')
    allow_any_instance_of(Map).to receive(:fetch_subways_by).and_return([
                                                                          {
                                                                            'line_name' => '地铁s1线(石厂-金安桥)',
                                                                            'line_uid' => '8e08d3bb7043c9149e95de7a',
                                                                            'pair_line_uid' => '2e868a270a6a144a08ccdde1',
                                                                            'stops' => []
                                                                          },
                                                                          {
                                                                            'line_name' => '地铁s1线(金安桥-石厂)',
                                                                            'pair_line_uid' => '8e08d3bb7043c9149e95de7a',
                                                                            'line_uid' => '2e868a270a6a144a08ccdde1',
                                                                            'stops' => []
                                                                          }
                                                                        ])
    expect do
      Rake::Task['region:sync_subways'].execute
    end.to change(Subway, :count).by(1)

    Rake::Task['region:sync_subways'].execute

    expect(Subway.count).to eq 1
  end

  it 'should not create duplicate stations' do
    Region::Base.create(name: '北京市', baidu_id: 'adfajasdjflkaf')
    allow_any_instance_of(Map).to receive(:fetch_subways_by).and_return([
                                                                          {
                                                                            'line_name' => '地铁s1线(石厂-金安桥)',
                                                                            'line_uid' => '8e08d3bb7043c9149e95de7a',
                                                                            'pair_line_uid' => '2e868a270a6a144a08ccdde1',
                                                                            'stops' => [
                                                                              {
                                                                                'uid' => '3e08d3bb7043c9149e25d47v',
                                                                                'name' => '西苑'
                                                                              }
                                                                            ]
                                                                          },
                                                                          {
                                                                            'line_name' => '地铁s1线(金安桥-石厂)',
                                                                            'pair_line_uid' => '8e08d3bb7043c9149e95de7a',
                                                                            'line_uid' => '2e868a270a6a144a08ccdde1',
                                                                            'stops' => [
                                                                              {
                                                                                'uid' => '3e08d3bb7043c9149e25d47v',
                                                                                'name' => '西苑'
                                                                              }
                                                                            ]
                                                                          }
                                                                        ])

    allow_any_instance_of(Map).to receive(:search_point).and_return([
                                                                      {
                                                                        'pname' => '广东省',
                                                                        'cityname' => '惠州市',
                                                                        'adname' => '惠城区',
                                                                        'address' => '江畔花园',
                                                                        'location' => '123.22,23.122'
                                                                      }
                                                                    ])

    expect do
      Rake::Task['region:sync_subways'].execute
    end.to change(Subway, :count).by(1)

    Rake::Task['region:sync_subways'].execute

    expect(Subway.count).to eq 1
    expect(Station.count).to eq 1
    expect(Location.count).to eq 1
  end

  it 'should not create duplicate stations' do
    Region::Base.create(name: '北京市', baidu_id: 'adfajasdjflkaf')
    allow_any_instance_of(Map).to receive(:fetch_subways_by).and_return([
                                                                          {
                                                                            'line_name' => '地铁s1线(石厂-金安桥)',
                                                                            'line_uid' => '8e08d3bb7043c9149e95de7a',
                                                                            'pair_line_uid' => '2e868a270a6a144a08ccdde1',
                                                                            'stops' => [
                                                                              {
                                                                                'uid' => '3e08d3bb7043c9149e25d47v',
                                                                                'name' => '西苑'
                                                                              }
                                                                            ]
                                                                          },
                                                                          {
                                                                            'line_name' => '地铁s1线(金安桥-石厂)',
                                                                            'pair_line_uid' => '8e08d3bb7043c9149e95de7a',
                                                                            'line_uid' => '2e868a270a6a144a08ccdde1',
                                                                            'stops' => [
                                                                              {
                                                                                'uid' => '3e08d3bb7043c9149e25d47v',
                                                                                'name' => '西苑'
                                                                              }
                                                                            ]
                                                                          }
                                                                        ])

    allow_any_instance_of(Map).to receive(:search_point).and_return([
                                                                      {
                                                                        'pname' => '广东省',
                                                                        'cityname' => '惠州市',
                                                                        'adname' => '惠城区',
                                                                        'address' => '江畔花园',
                                                                        'location' => '123.22,23.122'
                                                                      }
                                                                    ])

    Rake::Task['region:sync_subways'].execute
    Rake::Task['region:sync_subways'].execute
    expect(Subway.count).to eq 1
    expect(Subway.first.stations.count).to eq 1
    expect(Station.count).to eq 1
  end
end
