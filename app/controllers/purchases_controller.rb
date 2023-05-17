class PurchasesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_purchase, only: %i[show congratulations]

  def index
    @pagy, @purchases = pagy(Purchase.includes([:product], [:user]))
  end

  def buy_product
    @purchase = current_user.purchases.build(purchase_params)
    product = Product.find(params[:product_id])
    stock_product = product.stock

    respond_to do |format|
      if @purchase.save
        stock_product -= 1
        product.update(stock: stock_product)
        format.html { redirect_to congratulations_url(id: @purchase), notice: "compraste #{@purchase.product.name}" }
        format.json { render :congratulations, status: :created, location: @purchase }
      else
        format.html { redirect_to :back, alert: 'no se pudo completar la compra' }
        format.json { render json: @purchase.errors, status: :unprocessable_entity }
      end
    end
  end

  def congratulations
  end

  def show
  end

  private

  def set_purchase
    @purchase = Purchase.find(params[:id])
  end

  def purchase_params
    params.permit(:product_id)
  end
end
