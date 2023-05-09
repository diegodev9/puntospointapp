class ProductsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_product, only: %i[show edit update destroy]

  include CheckUserLevel
  before_action :check_user_level, except: %i[index show]

  def index
    @products = Product.all
  end

  def show
  end

  def new
    @product = current_user.products.build
  end

  def edit
  end

  def create
    @product = current_user.products.build(product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to products_url, notice: 'Product was successfully created.' }
        format.json { render 'products/index', status: :created, location: @products }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
  end

  def destroy
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    require.params(:product).permit(:active, :name, :price, :stock, :user_id)
  end
end