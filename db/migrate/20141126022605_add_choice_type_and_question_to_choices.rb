class AddChoiceTypeAndQuestionToChoices < ActiveRecord::Migration
  def change
    add_column :choices, :choice_type, :string
    add_column :choices, :question, :string
  end
end
