class CreatePubKeys < ActiveRecord::Migration
  def change
    create_table :pub_keys do |t|
      t.text :key

      t.timestamps null: false
    end
  end
end
