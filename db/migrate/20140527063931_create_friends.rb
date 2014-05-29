class CreateFriends < ActiveRecord::Migration
  def change
    create_table :friends do |t|
      t.integer :user_id
      t.integer :target_user_id

      t.timestamps
    end
    add_index :friends,  :user_id
    add_index :friends, [:user_id, :target_user_id], unique: true
  end
end
