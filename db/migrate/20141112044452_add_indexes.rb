class AddIndexes < ActiveRecord::Migration
  def change
  	add_index :outings, [:user_id, :event_id]
  	add_index :events, [:user_id]
  	add_index :polls, [:event_id]
  	add_index :choices, [:poll_id]
  end
end
