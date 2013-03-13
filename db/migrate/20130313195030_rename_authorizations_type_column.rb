class RenameAuthorizationsTypeColumn < ActiveRecord::Migration
  def up
    rename_column :authorizations, :type, :auth_type
  end

  def down
    rename_column :authorizations, :auth_type, :type
  end
end
