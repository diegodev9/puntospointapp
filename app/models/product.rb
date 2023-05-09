# frozen_string_literal: true

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
  has_many_attached :pictures, dependent: :destroy
  has_many :category_products, dependent: :destroy
  has_many :categories, through: :category_products

  validates :pictures, content_type: { in: %w[image/jpeg image/gif image/png],
                                                       message: 'formato inválido' },
                       size: { less_than: 1.megabytes,
                               message: 'la imagen supera 1MB' }

  before_destroy :purge_product_pictures

  def purge_product_pictures
    self.pictures.purge
  end
end
