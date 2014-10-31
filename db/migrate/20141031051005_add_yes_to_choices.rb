class AddYesToChoices < ActiveRecord::Migration
  def change
    add_column :choices, :yes, :boolean
  end
end
