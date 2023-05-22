# frozen_string_literal: true

# rubocop:disable Style/WordArray, Style/SymbolArray
Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'http://127.0.0.1:3000'
    resource '/users/*', headers: 'Authorization',
                         methods: [:get, :post, :options, :patch, :delete],
                         expose: 'Authorization'
    
    resource '/api/v1/users/*', headers: 'Authorization',
                                methods: [:get, :post, :options, :patch, :delete],
                                expose: 'Authorization'
  end
end
# rubocop:enable Style/WordArray, Style/SymbolArray
#