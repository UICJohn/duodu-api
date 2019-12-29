class AddContactsToPosts < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :phone, :string
    add_column :posts, :use_user_contact, :boolean, default: false
  end
end
