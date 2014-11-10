class AddPhoneNumberToPolls < ActiveRecord::Migration
  def change
    add_column :polls, :phone_number, :string
    add_column :polls, :user_id, :integer
  end
end
