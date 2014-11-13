class AddStartDateAndEndTimeToEvents < ActiveRecord::Migration
  def change
    add_column :events, :start_date, :datetime
    add_column :events, :end_time, :datetime
  end
end
