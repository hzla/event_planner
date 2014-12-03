class AddPaymentUserIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :payment_user_id, :string
  end
end
