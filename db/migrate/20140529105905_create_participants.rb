class CreateParticipants < ActiveRecord::Migration
  def change
    create_table :participants do |t|
      t.integer :wall_id
      t.integer :user_id

      t.timestamps
    end
    add_index :participants,  :wall_id
    add_index :participants,  :user_id
    add_index :participants, [:wall_id, :user_id], unique: true
  end
end
