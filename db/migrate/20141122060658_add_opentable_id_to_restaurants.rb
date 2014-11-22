class AddOpentableIdToRestaurants < ActiveRecord::Migration
  def change
    add_column :restaurants, :opentable_id, :integer
    add_column :restaurants, :cuisine, :string
    add_column :restaurants, :lat, :string
    add_column :restaurants, :long, :string
    add_column :restaurants, :pricing_info, :string
    add_column :restaurants, :popularity, :integer

  end
end
