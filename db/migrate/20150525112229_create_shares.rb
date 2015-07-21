class CreateShares < ActiveRecord::Migration
  def change
    create_table :shares do |t|
      t.string :name,                 null: false
      t.string :path,                 null: false
      t.integer :quotum,              null: false, default: 0

      t.timestamps null: false
    end

    add_index :shares, :path,                unique: true
  end
end
