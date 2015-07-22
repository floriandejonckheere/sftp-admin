class CreatePubKeys < ActiveRecord::Migration
  def change
    create_table :pub_keys do |t|
      t.string :title,                 null: false
      t.string :key,                   null: false
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
