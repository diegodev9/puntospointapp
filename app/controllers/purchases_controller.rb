# frozen_string_literal: true

# rubocop:disable Metrics/MethodLength, Metrics/AbcSize, Layout/LineLength
# purchases controller
class PurchasesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_purchase, only: %i[show congratulations]

  def index
    @pagy, @purchases = pagy(Purchase.includes([:product], [:user]))
  end

  def buy_product
    @purchase = current_user.purchases.build(purchase_params)
    product = Product.find(params[:product_id])
    @purchase.owner = product.user_id
    @purchase.category = product.category_ids
    stock_product = product.stock

    respond_to do |format|
      if @purchase.save
        stock_product -= 1
        product.update(stock: stock_product)
        PurchaseMailer.with(product_owner: @purchase.product.user,
                            product_data: "#{@purchase.product.name}, $#{@purchase.product.price}").purchase_mail.deliver_later

        format.html { redirect_to congratulations_url(id: @purchase), notice: "compraste #{@purchase.product.name}" }
        format.json { render :congratulations, status: :created, location: @purchase }
      else
        format.html { redirect_to :back, alert: 'no se pudo completar la compra' }
        format.json { render json: @purchase.errors, status: :unprocessable_entity }
      end
    end
  end

  def congratulations; end

  def show; end

  private

  def set_purchase
    @purchase = Purchase.find(params[:id])
  end

  def purchase_params
    params.permit(:product_id)
  end
end
# rubocop:enable Metrics/MethodLength, Metrics/AbcSize, Layout/LineLength
