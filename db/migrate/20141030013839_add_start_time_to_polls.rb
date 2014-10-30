class AddStartTimeToPolls < ActiveRecord::Migration
  def change
    add_column :polls, :start_time, :datetime
  end
end
