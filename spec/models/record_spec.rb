# frozen_string_literal: true

# == Schema Information
#
# Table name: records
#
#  id              :bigint           not null, primary key
#  action          :text
#  recordable_type :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  recordable_id   :bigint           not null
#  user_id         :bigint           not null
#
# Indexes
#
#  index_records_on_recordable  (recordable_type,recordable_id)
#  index_records_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe Record, type: :model do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:recordable) }
end
