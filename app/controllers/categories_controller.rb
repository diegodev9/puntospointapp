class CategoriesController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :check_user_level, only: %i[create update destroy]
  before_action :set_category, only: %i[show edit update destroy]

  def index
    @categories = Category.all.order(name: :asc)
  end

  def show; end

  def new; end

  def edit; end
  
  def create
    @category = Category.new(category_params)

    respond_to do |format|
      if @category.save
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

  def check_user_level
    redirect_to root_path, notice: 'no estas autorizado para hacer esto' unless user_signed_in? && current_user.admin?
  end
  
  def category_params
    params.require(:category).permit(:name)
  end
end
