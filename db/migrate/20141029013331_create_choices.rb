class CreateChoices < ActiveRecord::Migration
  def change
    create_table :choices do |t|
      t.string :value
      t.string :desc
      t.text :add_info
      t.integer :poll_id
      t.string :replyer_name
    end
  end
end
