class AddOwnerToParticipants < ActiveRecord::Migration
  def change
    add_column :participants, :owner, :boolean, default: false
  end
end
