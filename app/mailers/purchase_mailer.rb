class PurchaseMailer < ApplicationMailer
  default from: 'notifications@example.com'

  def purchase_mail
    @owner = params[:product_owner]
    @admins = User.all_admins.map{ |user| user.email unless user.id == @owner.id }.compact.split(',').join(', ')
    @product = params[:product_data]
    mail(to: @owner.email, cc: @admins, subject: 'venta de producto')
  end
end
