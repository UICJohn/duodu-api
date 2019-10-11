class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: 'User'

  after_create :create_reverse_connection

  private

  def create_reverse_connection
    FriendShip.create(friend: user, user: friend)
  end
end
