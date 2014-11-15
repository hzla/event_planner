class ChangeStartTimeTypeInEvents < ActiveRecord::Migration
  def change
		remove_column :events, :start_time, :string
  	add_column :events, :start_time, :datetime
  end
end
