# frozen_string_literal: true

json.purchase do
  json.id @purchase.id
  json.product @purchase.product.name
  json.price @purchase.product.price
end
