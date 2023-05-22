# frozen_string_literal: true

require 'rails_helper'
require 'devise/jwt/test_helpers'
require 'support/devise_for_request'
require 'support/database_cleaner'

RSpec.describe 'Apis', type: :request do
  let(:headers) { { 'Accept' => 'application/json', 'Content-Type' => 'application/json' } }
  let(:new_user) { create(:user, level: 1) }
  let(:new_client) { create(:user, level: 0) }
  let(:authorization_headers) { Devise::JWT::TestHelpers.auth_headers(headers, new_user) }

  before do
    sign_in new_client

    # crea categorias
    categories = create_list(:category, 5)
    # crea productos
    products = create_list(:product, 25, user_id: new_user.id)
    # asigna categorias a productos
    products.each do |product|
      categories.each.map(&:id).sample(3).each do |category|
        create(:category_product, product_id: product.id, category_id: category)
      end
    end
    # hace 50 compras para cliente
    50.times { create(:purchase, product_id: products.each.map(&:id).sample(1).join(), user_id: new_client.id) }
  end

  describe 'GET /mas_comprados' do
    it 'render a successful response' do
      get api_v1_mas_comprados_url, headers: authorization_headers, as: :json
      expect(response).to have_http_status(:success)
    end

    it 'prints most bought products by category' do
      get api_v1_mas_comprados_url, headers: authorization_headers, as: :json
      json = JSON.parse(response.body, symbolize_names: true)
      expect(json).to include(:mas_comprados)
    end
  end

  describe 'GET /mas_recaudado' do
    it 'render a successful response' do
      get api_v1_mas_recaudado_url, headers: authorization_headers, as: :json
      expect(response).to have_http_status(:success)
    end

    it 'prints most bought products an total price' do
      get api_v1_mas_recaudado_url, headers: authorization_headers, as: :json
      json = JSON.parse(response.body, symbolize_names: true)
      expect(json).to include(:mas_recaudado)
    end
  end
end
