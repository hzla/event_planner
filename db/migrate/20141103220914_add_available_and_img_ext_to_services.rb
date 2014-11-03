class AddAvailableAndImgExtToServices < ActiveRecord::Migration
  def change
  	add_column :services, :img_ext, :string, default: 'svg'
  	add_column :services, :available, :boolean, default: true
  end
end
