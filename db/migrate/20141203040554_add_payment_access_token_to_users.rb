class AddPaymentAccessTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :payment_access_token, :string
  end
end
