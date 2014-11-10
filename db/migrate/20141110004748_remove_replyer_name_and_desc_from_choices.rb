class RemoveReplyerNameAndDescFromChoices < ActiveRecord::Migration
  def change
  	remove_column :choices, :desc, :string
  	remove_column :choices, :replyer_name, :string
  end
end
