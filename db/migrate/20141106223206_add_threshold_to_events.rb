class AddThresholdToEvents < ActiveRecord::Migration
  def change
    add_column :events, :threshold, :integer
  end
end
