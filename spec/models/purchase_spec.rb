# frozen_string_literal: true

# == Schema Information
#
# Table name: purchases
#
#  id         :bigint           not null, primary key
#  category   :string
#  owner      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  product_id :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_purchases_on_product_id  (product_id)
#  index_purchases_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (product_id => products.id)
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe Purchase, type: :model do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:product) }
end
