# frozen_string_literal: true

# rubocop:disable Metrics/AbcSize, Metrics/MethodLength
# categories controller
class CategoriesController < ApplicationController
  before_action :authenticate_user!, except: %i[show]
  before_action :set_category, only: %i[show edit update destroy]

  include CheckUserLevel
  before_action :check_user_level, except: %i[index show]

  def index
    @pagy, @categories = pagy(Category.list_all_categories)
  end

  def show
    @pagy, @category_products = pagy(@category.products.includes([:pictures_attachments]))
    @records = Record.includes([:user]).where(recordable_id: @category.id).order(created_at: :desc)
  end

  def new
    @category = Category.new
  end

  def edit; end

  def create
    @category = Category.new(category_params)

    respond_to do |format|
      if @category.save
        @record = Record.new(recordable: @category, action: category_params[:name].to_s, user_id: current_user.id)
        @record.save
        format.html { redirect_to categories_url, notice: 'Category was successfully created.' }
        format.json { render 'categories/index', status: :created, location: @categories }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @category.update(category_params)
        @record = Record.new(recordable: @category, action: category_params[:name].to_s, user_id: current_user.id)
        @record.save
        format.html { redirect_to category_url(@category), notice: 'Category was successfully updated.' }
        format.json { render 'categories/index', status: :ok, location: @categories }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @category.destroy
    redirect_to categories_url
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name)
  end
end
# rubocop:enable Metrics/AbcSize, Metrics/MethodLength
