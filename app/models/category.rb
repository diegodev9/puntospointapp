# frozen_string_literal: true

# == Schema Information
#
# Table name: categories
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_categories_on_name  (name) UNIQUE
#
class Category < ApplicationRecord
  has_many :category_products, dependent: :destroy
  has_many :products, through: :category_products

  validates :name, uniqueness: true

  scope :list_all_categories, -> { all.order(name: :asc) }
  scope :list_categories_for_options, -> { all.map { |cat| [cat.name, cat.id] } }
end
