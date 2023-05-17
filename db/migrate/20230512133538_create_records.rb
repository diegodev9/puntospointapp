# frozen_string_literal: true

class CreateRecords < ActiveRecord::Migration[6.1]
  def change
    create_table :records do |t|
      t.references :recordable, polymorphic: true, null: false
      t.references :user, null: false, foreign_key: true
      t.text :action

      t.timestamps
    end
  end
end
