class AddExpirationToEvents < ActiveRecord::Migration
  def change
    add_column :events, :expiration, :datetime
    add_column :events, :recurring, :string
  end
end
