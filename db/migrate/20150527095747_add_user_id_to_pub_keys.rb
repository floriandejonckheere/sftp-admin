class AddUserIdToPubKeys < ActiveRecord::Migration
  def change
    add_column :pub_keys, :user_id, :integer
  end
end
