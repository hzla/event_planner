class ChangeDescriptionInEvents < ActiveRecord::Migration
  def change
  	rename_column :events, :desc, :comment
  end
end
