class AddCompleteToEvents < ActiveRecord::Migration
  def change
    add_column :events, :complete, :boolean, default: false
  end
end
