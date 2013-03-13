class DropApiTokens < ActiveRecord::Migration
  def up
    drop_table :api_tokens
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
