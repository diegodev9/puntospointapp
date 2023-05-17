require 'rails_helper'
require 'support/database_cleaner'
require 'support/devise_for_request'

RSpec.describe 'Users', type: :request do
  let(:new_user) { create(:user, level: 1) }
  let(:new_product) { create(:product, user_id: new_user.id) }
  let(:new_client) { create(:user, level: 0) }
  let(:new_purchase) { create(:purchase, user_id: new_client.id, product_id: new_product.id) }

  before do
    sign_in new_client
  end

  describe 'GET /purchases' do
    it 'renders a successful response' do
      get purchases_user_url(new_client.id)
      expect(response).to be_successful
    end

    it 'list all my purchases' do
      new_purchase
      get purchases_user_url(new_client.id)
      expect(response.body).to include(new_product.name)
    end
  end

end
