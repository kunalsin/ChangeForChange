class ItemPricesController < ApplicationController
  include BreadExpressHelpers::Cart


  #before_action :check_login, except: [:show, :index]
  before_action :set_item, only: [:show, :update, :destroy]
  #authorize_resource
  
  def index
    @active = Item.active.alphabetical.paginate(:page => params[:page]).per_page(10)
    @inactive = Item.inactive.alphabetical.paginate(:page => params[:page]).per_page(10)
  end

  def show
    @history = @item.item_prices.chronological
    @similar_items = Item.active.for_category(@item.category).order("RANDOM()").where.not(id: @item.id)[1..3]
  end

  def edit
    @item = Item.find(params[:id])
    item_price = @item.item_prices.build
  end

  def new
    @item_price = ItemPrice.new
  end

  def create
    @item_price = ItemPrice.new(item_price_params)
    if @item_price.save
      redirect_to @item, notice: "#{@item_price.item.name} has a new price."
    else
      render action: 'new'
    end
  end

  def update
    if @item_price.update(item_price_params)
      redirect_to @item, notice: "#{@item_price.item.name} was revised in the system."
    else
      render action: 'edit'
    end
  end

  def destroy
    @item_price.destroy
    redirect_to items_url, notice: "#{@item.name} was removed from the system."
  end

  private
  def set_item
    @item_price = ItemPrice.find(params[:id])
  end

  def item_params
    params.require(:item_price).permit(:active, :id, :name, :description, :category, :weight, :picture, :units_per_item, item_prices_attributes: [:id, :price, :start_date, :end_date])
  end

end



