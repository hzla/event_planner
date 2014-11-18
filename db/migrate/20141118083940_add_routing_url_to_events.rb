class AddRoutingUrlToEvents < ActiveRecord::Migration
  def change
    add_column :events, :routing_url, :string
  end
end
