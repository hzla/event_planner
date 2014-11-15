class CreateLogs < ActiveRecord::Migration
  def change
    create_table :logs do |t|
      t.integer :event_id
      t.text :message

      t.timestamps
    end
  end
end
