class CreateAttachment < ActiveRecord::Migration[5.2]
  def change
    create_table :attachments do |t|
      t.integer :attachable_id
      t.string  :attachable_type
      t.attachment :file

      t.timestamps
    end
    add_index :attachments, [:attachable_type, :attachable_id]
  end
end
