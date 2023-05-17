class PurchasesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_purchase, only: :show

  include CheckUserLevel

  def index
    @pagy, @purchases = pagy(Purchase.by_client(current_user.id))
  end

  def buy_product
    params.permit(:product_id)
    @purchase = current_user.purchases.build(product_id: params[:product_id])

    respond_to do |format|
      if @purchase.save
        format.html { redirect_to congratulations_url(@purchase), notice: "compraste #{@purchase.product.name}" }
        format.json { render 'purchases/congratulations', status: :created, location: @purchase }
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
end
