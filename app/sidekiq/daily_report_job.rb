# frozen_string_literal: true

# daily report job
class DailyReportJob
  include Sidekiq::Job
  queue_as :default

  def perform
    DailyReportMailer.with(products_data: find_purchases).daily_report_mail.deliver_later if find_purchases.present?

    DailyReportJob.set(wait: 1.day).perform_async
  end

  def find_purchases
    beginning = Time.zone.yesterday.beginning_of_day.to_datetime
    ending = Time.zone.yesterday.end_of_day
    Purchase.where(created_at: [beginning..ending]).map { |purchase| purchase.product.name }
  end
end
