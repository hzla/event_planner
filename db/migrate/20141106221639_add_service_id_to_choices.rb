class AddServiceIdToChoices < ActiveRecord::Migration
  def change
    add_column :choices, :service_id, :integer
    add_column :choices, :time, :datetime
  end
end
