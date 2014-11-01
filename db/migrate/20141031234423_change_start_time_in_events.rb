class ChangeStartTimeInEvents < ActiveRecord::Migration
  def change
  	change_column :events, :start_time, :string
  end
end
