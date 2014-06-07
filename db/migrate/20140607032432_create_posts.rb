class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.integer :participant_id
      t.text :content

      t.timestamps
    end
    add_index :posts, [:participant_id, :created_at]
  end
end
