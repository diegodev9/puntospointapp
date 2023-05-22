class AddCategoryidsAndOwneridToPurchases < ActiveRecord::Migration[6.1]
  def change
    add_column :purchases, :category, :string
    add_column :purchases, :owner, :integer
  end
end
