class CreateFriendRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :friend_requests do |t|
      t.references  :user, foreign_key: true
      t.references  :friend, foreign_key: {to_table: 'users'}
      t.integer     :status, default: 0
      t.timestamps
    end
  end
end
