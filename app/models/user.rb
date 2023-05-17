# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  address                :string
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  level                  :integer
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :jwt_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         jwt_revocation_strategy: JwtDenylist

  has_many :products
  has_many :records, as: :recordable, dependent: :destroy
  has_many :purchases, dependent: :destroy
  has_many :products, through: :purchases

  before_create :set_user_level

  enum level: {
    client: 0,
    admin: 1
  }

  scope :all_admins, -> { where(level: 1) }

  def set_user_level
    self.level = 0 if level.blank?
  end
end
