# frozen_string_literal: true

class SharesUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :shares_users, :id => false do |t|
      t.references :share, :null => false, :foreign_key => true
      t.references :user, :null => false, :foreign_key => true
    end

    add_index :shares_users, %i[share user], unique: true
    add_index :shares_users, %i[user share], unique: true
  end
end
