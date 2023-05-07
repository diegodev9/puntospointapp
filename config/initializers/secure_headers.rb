# frozen_string_literal: true

# rubocop:disable Lint/PercentStringArray, Style/PercentLiteralDelimiters
SecureHeaders::Configuration.default do |config|
  config.csp = {
    default_src: %w('self'),
    script_src: %w('self' 'unsafe-inline'),
    style_src: %w('self' 'unsafe-inline' https://fonts.googleapis.com/ https://fonts.gstatic.com),
    font_src: %w('self' https://fonts.googleapis.com/ https://fonts.gstatic.com),
    img_src: %w('self' data:)
  }
end
# rubocop:enable Lint/PercentStringArray, Style/PercentLiteralDelimiters
