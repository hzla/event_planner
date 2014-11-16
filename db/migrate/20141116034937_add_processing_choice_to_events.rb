class AddProcessingChoiceToEvents < ActiveRecord::Migration
  def change
    add_column :events, :processing_choice, :string
  end
end
