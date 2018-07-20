# frozen_string_literal: true

class CreateKeys < ActiveRecord::Migration[5.2]
  def change
    create_table :keys do |t|
      t.string :title, :null => false
      t.string :key, :null => false
      t.references :user, :null => false, :foreign_key => true

      t.timestamps
    end
  end
end
