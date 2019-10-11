require 'open-uri'

class FetchAvatarWorker
  include Sidekiq::Worker

  sidekiq_options retry: 2

  def perform(user_id, url)
    if (user = User.find_by(id: user_id))
      user.avatar.attach(io: open(url), filename: Digest::SHA256.base64digest("#{user.id}/#{user.created_at}_avatar.jpeg"))
    end
  end
end
