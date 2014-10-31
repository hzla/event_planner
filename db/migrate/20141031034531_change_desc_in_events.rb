class ChangeDescInEvents < ActiveRecord::Migration
  def change
  	change_column :events, :desc, :text
  end
end
