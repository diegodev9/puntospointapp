# frozen_string_literal: true

require 'rails_helper'
require 'support/devise_for_request'
require 'support/database_cleaner'

RSpec.describe 'Categories', type: :request do
  let(:new_category) { create(:category) }
  let(:new_user) { create(:user, level: 1) }
  let(:new_client) { create(:user, level: 0) }

  before do
    sign_in new_user
    new_category
  end

  describe 'GET /index' do
    it 'renders a successful response' do
      get categories_url
      expect(response).to be_successful
    end

    it 'contains a categories list' do
      get categories_url
      expect(response.body).to include(new_category.name)
    end
  end

  describe 'GET /show' do
    it 'renders a successful response' do
      get category_url(new_category)
      expect(response).to be_successful
    end
  end

  describe 'GET /new', skip_before: true do
    it 'renders a successful response' do
      get new_category_url
      expect(response).to be_successful
    end
  end

  describe 'GET /edit' do
    it 'renders a successful response' do
      get edit_category_url(new_category)
      expect(response).to be_successful
    end
  end

  describe 'POST /create', skip_before: true do
    before do
      sign_in new_user
    end

    context 'with unique name and credentials' do
      it 'creates category' do
        expect do
          post categories_url, params: { name: 'categoria1' }, as: :json
        end.to change(Category, :count).by(1)
      end

      it 'have status created' do
        post categories_url, params: { name: 'categoria2' }, as: :json
        expect(response).to have_http_status(:created)
      end
    end

    context 'with a repeated name and credentials' do
      it 'does not creates a category' do
        post categories_url, params: { name: 'categoria1' }, as: :json
        expect do
          post categories_url, params: { name: 'categoria1' }, as: :json
        end.to change(Category, :count).by(0)
      end
    end

    context 'without credentials' do
      before do
        sign_out new_user
        sign_in new_client
      end

      it 'redirects to root path' do
        post categories_url, params: { name: 'categoria1' }, as: :json
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'PATCH /update' do
    context 'with unique name and credentials' do
      it 'updates the category name' do
        patch category_url(new_category), params: { name: 'nueva categoria' }, as: :json
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with a repeated name and credentials' do
      let(:another_category) { create(:category) }

      it 'does not updates the category name' do
        category_name = another_category.name
        patch category_url(new_category), params: { name: category_name }, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'without credentials' do
      before do
        sign_out new_user
        sign_in new_client
      end

      it 'redirects to root path' do
        patch category_url(new_category), params: { name: 'nueva categoria' }, as: :json
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'DELETE /destroy' do
    context 'with credentials' do
      it 'deletes the given category' do
        expect do
          delete category_url(new_category)
        end.to change(Category, :count).by(-1)
      end
    end

    context 'without credentials' do
      before do
        sign_out new_user
        sign_in new_client
      end

      it 'deletes the given category' do
        delete category_url(new_category)
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
