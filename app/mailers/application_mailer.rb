# frozen_string_literal: true

# applicatin mailer
class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com'
  layout 'mailer'
end
