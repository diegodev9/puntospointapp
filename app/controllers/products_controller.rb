# frozen_string_literal: true

class ProductsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_product, only: %i[show edit update destroy]

  include CheckUserLevel
  include Pagy::Backend
  before_action :check_user_level, except: %i[index show]

  def index
    @pagy, @products = if params[:order_by].present?
                  case params[:order_by]
                  when 'mas viejo'
                    pagy(Product.all_by_older)
                  when 'mas nuevo'
                    pagy(Product.all_by_newer)
                  when 'nombre A-Z'
                    pagy(Product.all_by_name_asc)
                  when 'nombre Z-A'
                    pagy(Product.all_by_name_desc)
                  when 'mayor precio'
                    pagy(Product.all_by_high_price)
                  when 'menor precio'
                    pagy(Product.all_by_low_price)
                  end
                else
                  pagy(Product.all_by_newer)
                end

    @order_by_options = [['mas nuevo'], ['mas viejo'], ['nombre A-Z'], ['nombre Z-A'], ['mayor precio'],
                         ['menor precio']]
  end

  def show; end

  def new
    @product = current_user.products.build
  end

  def edit; end

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
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to product_url(@product), notice: 'Product was successfully updated.' }
        format.json { render 'products/index', status: :ok, location: @products }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @product.destroy
    redirect_to products_url
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:active, :name, :price, :stock, :user_id, pictures: [])
  end
end
