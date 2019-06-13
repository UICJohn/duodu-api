class AddTagsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :tags, :string, array: true, default: []
  end
end
