class CreateRestaurants < ActiveRecord::Migration
  def change
    create_table :restaurants do |t|
      t.string :name
      t.string :address
      t.integer :review_count
      t.integer :pricing
      t.float :rating
      t.string :city
      t.string :state

      t.timestamps
    end
  end
end
