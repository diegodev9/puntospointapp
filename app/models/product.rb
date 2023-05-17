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
  has_many :records, as: :recordable, dependent: :destroy
  has_many :purchases, dependent: :destroy
  has_many :users, through: :purchases


  validates :pictures, content_type: { in: %w[image/jpeg image/gif image/png],
                                       message: 'formato inválido' },
                       size: { less_than: 1.megabytes,
                               message: 'la imagen supera 1MB' }

  before_destroy :purge_product_pictures

  scope :all_active, -> { where(active: true).includes([:pictures_attachments]) }
  scope :all_by_newer, -> { all_active.order(created_at: :desc) }
  scope :all_by_older, -> { all_active.order(created_at: :asc) }
  scope :all_by_name_asc, -> { all_active.order(name: :asc) }
  scope :all_by_name_desc, -> { all_active.order(name: :desc) }
  scope :all_by_high_price, -> { all_active.order(price: :desc) }
  scope :all_by_low_price, -> { all_active.order(price: :asc) }

  def purge_product_pictures
    self.pictures.purge
  end

  def product_image_on_disk(picture)
    ActiveStorage::Blob.service.path_for(picture.key)
  end
end
