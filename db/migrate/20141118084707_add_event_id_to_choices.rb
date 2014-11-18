class AddEventIdToChoices < ActiveRecord::Migration
  def change
    add_column :choices, :event_id, :integer
  end
end
