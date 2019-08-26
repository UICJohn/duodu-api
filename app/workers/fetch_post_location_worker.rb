class FetchPostLocationWorker
  include Sidekiq::Worker
  sidekiq_options :retry => 2

  def perform(post_id)
    if post = Post.find_by(id: post_id)
      location = Map.new.get_location_info(post.lon.to_f, post.lat.to_f)
      post.update_attributes!(
        province: location['province'],
        country:  ISO3166::Country.find_country_by_name(location['nation']).alpha2,
        city:     location['city'],
        suburb:   location['district']
      )
    end
  end
end