class RemoveCompleteAndFinishedFromEvents < ActiveRecord::Migration
  def change
  	remove_column :events, :complete
  	remove_column :events, :finished
  end
end
