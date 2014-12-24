class AddTimestampsToChoices < ActiveRecord::Migration
  def change
    add_column :choices, :created_at, :datetime
    add_column :choices, :updated_at, :datetime
  end
end
