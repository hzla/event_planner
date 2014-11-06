class AddConfirmationIdToEvents < ActiveRecord::Migration
  def change
    add_column :events, :confirmation_id, :integer
  end
end
