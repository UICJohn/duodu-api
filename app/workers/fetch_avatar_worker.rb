require "open-uri"

class FetchAvatarWorker

  include Sidekiq::Worker

  sidekiq_options :retry => 2

  def perform(user_id, url)
    if user = User.find_by(id: user_id)
      user.update_attributes(avatar: open(url))
    end
  end

end