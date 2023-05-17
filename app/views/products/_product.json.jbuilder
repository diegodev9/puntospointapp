# frozen_string_literal: true

json.extract! product, :id, :active, :name, :price, :stock, :user_id, :created_at, :updated_at, pictures: [],
                                                                                                category_ids: []
json.url product_url(product, format: :json)
