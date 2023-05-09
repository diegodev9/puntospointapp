# == Schema Information
#
# Table name: category_products
#
#  id          :bigint           not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  category_id :bigint           not null
#  product_id  :bigint           not null
#
# Indexes
#
#  index_category_products_on_category_id  (category_id)
#  index_category_products_on_product_id   (product_id)
#
# Foreign Keys
#
#  fk_rails_...  (category_id => categories.id)
#  fk_rails_...  (product_id => products.id)
#
require 'rails_helper'

RSpec.describe CategoryProduct, type: :model do
  describe 'has_many and belongs_to conditions' do
    it { is_expected.to belong_to(:category) }
    it { is_expected.to belong_to(:product) }
  end
end
