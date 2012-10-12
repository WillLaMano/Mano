class CreateApiTokens < ActiveRecord::Migration
  def change
    create_table :api_tokens do |t|
      t.integer :user_id
      t.string :type
      t.string :access_token

      t.timestamps
    end
    add_index :api_tokens, :user_id
  end
end
