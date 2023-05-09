require 'rails_helper'
require 'support/database_cleaner'
require 'support/devise_for_request'

RSpec.describe 'Products', type: :request do
  let(:new_user) { create(:user, level: 1) }
  let(:new_product) { build(:product) }
  
  before do
    sign_in new_user
    new_product.user_id = new_user.id
    new_product.save
  end
  
  describe 'GET /index' do
    it 'renders a successful response' do
      get products_url
      expect(response).to be_successful
    end

    it 'lists all products' do
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

  describe 'GET /new' do
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

    end

    context 'without credentials', skip_before: true do
      pending
    end
  end
end
