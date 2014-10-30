class CreatePolls < ActiveRecord::Migration
  def change
    create_table :polls do |t|
      t.boolean :answered, default: false
      t.string :url
      t.integer :event_id
    end
  end
end
