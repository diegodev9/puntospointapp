# frozen_string_literal: true

class CreateCategoryProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :category_products do |t|
      t.references :category, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true

      t.timestamps
    end
  end
end
