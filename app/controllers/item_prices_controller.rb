class ItemPricesController < ApplicationController
  include BreadExpressHelpers::Cart

  before_action :check_login
  before_action :set_item_prices, only: [:show, :edit, :update, :destroy]
  authorize_resource
  
  def index
  end

  def show
  end

  def edit
  end

  def new
    @item_price = ItemPrice.new
  end

  def create
    @item_price = ItemPrice.new(item_price_params)
    if @item_price.save
      redirect_to item_path(@item_price.item), notice: "#{@item_price.item.name} has a new price."
    else
      redirect_to item_path(@item_price.item), notice: "Enter a valid price"
    end
  end

  def update
  end

  def destroy
  end

  private
  def set_item_prices
    @item_price = ItemPrice.find(params[:id])
  end

  def item_price_params
    params.require(:item_price).permit(:id, :item_id, :price, :start_date, :end_date)
  end

end



