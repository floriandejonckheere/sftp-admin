class CreateShares < ActiveRecord::Migration
  def change
    create_table :shares do |t|
      t.text :name
      t.text :path

      t.timestamps null: false
    end
  end
end
