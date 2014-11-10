class RemoveStartTimeFromPolls < ActiveRecord::Migration
  def change
  	remove_column :polls, :start_time, :datetime
  end
end
