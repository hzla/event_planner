class AddImageUrlToChoices < ActiveRecord::Migration
  def change
    add_column :choices, :image_url, :string
  end
end
