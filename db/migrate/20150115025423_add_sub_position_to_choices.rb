class AddSubPositionToChoices < ActiveRecord::Migration
  def change
    add_column :choices, :sub_position, :integer
  end
end
