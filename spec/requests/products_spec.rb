# frozen_string_literal: true

require 'rails_helper'
require 'support/database_cleaner'
require 'support/devise_for_request'

RSpec.describe 'Products', type: :request do
  let(:new_user) { create(:user, level: 1) }
  let(:new_categories) { create_list(:category, 5) }
  let(:new_client) { create(:user, level: 0) }
  let(:build_product) { build(:product, user_id: new_user.id) }
  let(:new_product) { create(:product, user_id: new_user.id) }

  before do
    sign_in new_user
  end

  describe 'GET /index' do
    it 'renders a successful response' do
      get products_url
      expect(response).to be_successful
    end

    it 'lists all products' do
      new_product
      get products_url
      expect(response.body).to include(new_product.name)
    end
  end

  describe 'GET /show' do
    it 'renders a successful response' do
      get products_url(new_product.id)
      expect(response).to be_successful
    end
  end

  describe 'GET /new', skip_before: true do
    it 'renders a successful response' do
      get new_product_url
      expect(response).to be_successful
    end
  end

  describe 'GET /edit' do
    it 'renders a successful response' do
      get edit_product_url(new_product.id)
      expect(response).to be_successful
    end
  end

  describe 'POST /create' do
    context 'with credentials' do
      it 'creates the product' do
        expect do
          post products_url, params: { product: build_product }, as: :json
        end.to change(Product, :count).by(1)
      end

      it 'have status created' do
        post products_url, params: { product: build_product }, as: :json
        expect(response).to have_http_status(:created)
      end

      it 'creates a new record' do
        expect do
          post products_url, params: { product: build_product }, as: :json
        end.to change(Record, :count).by(1)
      end

      it 'saves the product categories' do
        product_params = { name: 'producto1', stock: 99, active: 1, price: 10,
                           user_id: new_user.id, category_ids: new_categories.each.map { |c| c.id.to_s }.first(3) }

        expect do
          post products_url, params: { product: product_params }, as: :json
        end.to change(CategoryProduct, :count).by(3)
      end
    end

    context 'without credentials' do
      before do
        sign_out new_user
        sign_in new_client
      end

      it 'does not create a product' do
        expect do
          post products_url, params: { product: build_product }, as: :json
        end.to change(Product, :count).by(0)
      end
    end
  end

  describe 'PATCH /update' do
    context 'with credentials' do
      it 'updates a product' do
        patch product_url(new_product.id), params: { stock: 2 }, as: :json
        expect(response).to have_http_status(:ok)
      end

      it 'creates a new record' do
        expect do
          patch product_url(new_product.id), params: { stock: 2 }, as: :json
        end.to change(Record, :count).by(1)
      end
    end

    context 'without credentials' do
      before do
        sign_out new_user
        sign_in new_client
      end

      it 'does not update a product and redirects to root path' do
        patch product_url(new_product.id), params: { stock: 2 }, as: :json
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'DELETE /destroy' do
    before do
      new_product
    end

    context 'with credentials' do
      it 'deletes the product' do
        expect do
          delete product_url(new_product)
        end.to change(Product, :count).by(-1)
      end
    end

    context 'without credentials' do
      before do
        sign_out new_user
        sign_in new_client
      end

      it 'redirects to root path' do
        delete product_url(new_product)
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
