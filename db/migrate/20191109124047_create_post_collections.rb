class CreatePostCollections < ActiveRecord::Migration[6.1]
  def change
    create_table :post_collections do |t|
      t.references :user
      t.references :post
      t.timestamps
    end
  end
end
