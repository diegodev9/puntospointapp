# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  address                :string
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
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
require 'rails_helper'
require 'support/database_cleaner'

RSpec.describe User, type: :model do
  let(:new_user) { build(:user) }

  describe 'has_many and belongs conditions' do
    it { is_expected.to have_many(:products).dependent(:destroy) }
  end

  describe 'before create' do
    context 'when create a new user' do
      it 'sets level client' do
        expect do
          new_user.save
        end.to change(new_user, :level).to('client')
      end
    end
  end
end
