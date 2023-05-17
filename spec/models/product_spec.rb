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
require 'rails_helper'
require 'support/database_cleaner'

RSpec.describe Product, type: :model do
  describe 'has_many and belongs conditions' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many_attached(:pictures) }
    it { is_expected.to have_many(:category_products) }
    it { is_expected.to have_many(:categories).through(:category_products) }
    it { is_expected.to have_many(:records).dependent(:destroy) }
    it { is_expected.to have_many(:purchases).dependent(:destroy) }
    it { is_expected.to have_many(:users).through(:purchases) }
  end
end
