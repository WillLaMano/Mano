class CreateAuthorizations < ActiveRecord::Migration
  def change
    create_table :authorizations do |t|
      t.string :type
      t.string :auth_token
      t.integer :user_id

      t.timestamps
    end
  end
end
