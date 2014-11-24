class AddMoreIndexes < ActiveRecord::Migration
  def change
  	add_index :authorizations, [:user_id, :uu_id]
  	add_index :polls, [:user_id]
  	add_index :choices, [:event_id, :value]
  end
end
