class AddPhoneNumberAndUuIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :phone_number, :string
    add_column :users, :uu_id, :integer
  end
end
