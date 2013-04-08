class AddAuthSecretToAuthorizations < ActiveRecord::Migration
  def change
    add_column :authorizations, :auth_secret, :string
  end
end
