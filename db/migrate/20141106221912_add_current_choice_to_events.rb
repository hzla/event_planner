class AddCurrentChoiceToEvents < ActiveRecord::Migration
  def change
    add_column :events, :current_choice, :string
  end
end
