class AddNameAndDescToPolls < ActiveRecord::Migration
  def change
    add_column :polls, :name, :string
    add_column :polls, :desc, :string
  end
end
