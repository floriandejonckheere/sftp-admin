class SharesUsers < ActiveRecord::Migration
  def change
    create_table :shares_users, :id => false do |t|
      t.integer :share_id,            null: false
      t.integer :user_id,             null: false
    end
  end
end
