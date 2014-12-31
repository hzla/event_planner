class AddPositionToChoices < ActiveRecord::Migration
  def change
    add_column :choices, :position, :string
    add_column :choices, :integer, :string
  end
end
