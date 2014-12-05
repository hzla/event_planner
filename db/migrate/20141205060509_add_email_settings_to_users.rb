class AddEmailSettingsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :mail_on_vote, :boolean, default: true
    add_column :users, :mail_on_res_success, :boolean, default: true
    add_column :users, :mail_on_res_failure, :boolean, default: true
    add_column :users, :mail_on_res_24_hour, :boolean, default: true
  end
end
