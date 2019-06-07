class AddTagIdsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :occupations, :string, array: true, default: []
    add_column :users, :hobby, :string, array: true, default: []
  end
end
