# == Schema Information
#
# Table name: products
#
#  id         :bigint           not null, primary key
#  active     :boolean
#  name       :string
#  price      :float
#  stock      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_products_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Product < ApplicationRecord
  belongs_to :user
  has_many_attached :pictures
  has_many :category_products, dependent: :destroy
  has_many :categories, through: :category_products
end
