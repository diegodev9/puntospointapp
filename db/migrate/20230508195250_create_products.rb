# frozen_string_literal: true

class CreateProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :products do |t|
      t.string :name
      t.integer :stock
      t.float :price
      t.boolean :active

      t.timestamps
    end
  end
end
