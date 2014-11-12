class CreateOutings < ActiveRecord::Migration
  def change
    create_table :outings do |t|
      t.integer :user_id
      t.integer :event_id
    end
  end
end
