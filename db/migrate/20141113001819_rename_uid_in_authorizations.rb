class RenameUidInAuthorizations < ActiveRecord::Migration
  def change
  	rename_column :authorizations, :uid, :uu_id
  end
end
