# frozen_string_literal: true
#
# daily report mailer
class DailyReportMailer < ApplicationMailer
  default from: 'notifications@example.com'

  def daily_report_mail
    @admins = User.all_admins.map(&:email).compact.split(',').join(', ')
    @products = params[:products_data]
    mail(to: @admins, subject: 'reporte diario')
  end
end
