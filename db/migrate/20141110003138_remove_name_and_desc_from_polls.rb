class RemoveNameAndDescFromPolls < ActiveRecord::Migration
  def change
  	remove_column :polls, :name, :string
  	remove_column :polls, :desc, :string
  end
end
