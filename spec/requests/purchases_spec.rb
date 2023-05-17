# frozen_string_literal: true

require 'rails_helper'
require 'support/database_cleaner'
require 'support/devise_for_request'

RSpec.describe 'Purchases', type: :request do
  let(:new_client) { create(:user, level: 0) }
  let(:new_user) { create(:user, level: 1) }
  let(:new_product) { create(:product, user_id: new_user.id) }
  let(:new_purchase) { create(:purchase, user_id: new_client.id, product_id: new_product.id) }

  before do
    sign_in new_client
  end

  describe 'GET /index' do
    it 'render a successful response' do
      get purchases_url
      expect(response).to be_successful
    end
  end

  describe 'POST /buy_product' do
    it 'creates a new purchase' do
      expect do
        post buy_product_url, params: { product_id: new_product.id }
      end.to change(Purchase, :count).by(1)
    end
  end
end
