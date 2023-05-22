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
      categories.map(&:id).sample(3).each do |category|
        create(:category_product, product_id: product.id, category_id: category)
      end
    end
    # hace 50 compras para cliente
    50.times { create(:purchase, product_id: products.each.map(&:id).sample(1).join(), user_id: new_client.id) }
  end
  
  describe 'POST /users/sign_in' do
    it 'returns an authorization bearer when user is admin' do
      post new_api_v1_user_session_url, params: { user: { email: new_user.email, password: '123456' } }, as: :json
      expect(response.headers).to include('Authorization')
    end

    it 'does not returns an authorization bearer when user is not admin' do
      post new_api_v1_user_session_url, params: { user: { email: new_client.email, password: '123456' } }, as: :json
      expect(response.body).to include('no estas autorizado')
    end
  end

  describe 'GET /mas_comprados' do
    it 'render a successful response' do
      get api_v1_mas_comprados_url, headers: authorization_headers, as: :json
      expect(response).to have_http_status(:success)
    end

    it 'prints most bought products by category' do
      get api_v1_mas_comprados_url, headers: authorization_headers, as: :json
      json = JSON.parse(response.body, symbolize_names: true)
      expect(json).to include(success: 'true')
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
      expect(json).to include(success: 'true')
    end
  end

  describe 'GET /listar_compras' do
    given_params = { "listar_compras": { "fecha_desde": '01/05/2023', "fecha_hasta": '31/05/2023', "category": '38',
                                           "user_id": '42', "owner": '37' } }
    it 'render a successful response' do
      get api_v1_listar_compras_url, headers: authorization_headers, params: given_params, as: :json
      expect(response).to have_http_status(:success)
    end

    it 'prints list according to params' do
      get api_v1_listar_compras_url, headers: authorization_headers, params: given_params, as: :json
      json = JSON.parse(response.body, symbolize_names: true)
      expect(json).to include(success: 'true')
    end
  end

  describe 'GET /cantidad_compras' do
    given_params = { "cantidad_compras": { "fecha_desde": "01/05/2023", "fecha_hasta": "31/05/2023", "granularidad": "hora" } }
    it 'render a successful response' do
      get api_v1_cantidad_compras_url, headers: authorization_headers, params: given_params, as: :json
      expect(response).to have_http_status(:success)
    end

    it 'prints list according to params' do
      get api_v1_cantidad_compras_url, headers: authorization_headers, params: given_params, as: :json
      json = JSON.parse(response.body, symbolize_names: true)
      expect(json).to include(success: 'true')
    end
  end
end
