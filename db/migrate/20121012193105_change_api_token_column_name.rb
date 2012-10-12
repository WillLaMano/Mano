class ChangeApiTokenColumnName < ActiveRecord::Migration
  def up
    rename_column :api_tokens, :type, :api_type
  end

  def down
    rename_column :api_tokens, :api_type, :type
  end
end
