class AddConfirmedAttendingToPolls < ActiveRecord::Migration
  def change
    add_column :polls, :confirmed_attending, :boolean
  end
end
