class AddTagIdsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :tag_ids, :integer, array: true, default: []
  end
end
