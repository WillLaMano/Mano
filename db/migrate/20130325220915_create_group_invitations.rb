class CreateGroupInvitations < ActiveRecord::Migration
  def change
    create_table :group_invitations do |t|
      t.string :token
      t.string :invitee_email
      t.integer :user_id
      t.integer :group_id

      t.timestamps
    end

    add_index :group_invitations, :token, :unique => true

  end
end
