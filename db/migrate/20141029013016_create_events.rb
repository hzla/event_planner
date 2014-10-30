class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.boolean :finished, default: false
      t.integer :user_id
      t.integer :service_id
      t.string :name
      t.string :desc
      t.datetime :start_time
    end
  end
end
