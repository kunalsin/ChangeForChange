class ItemsController < ApplicationController
  include BreadExpressHelpers::Cart


  before_action :check_login, except: [:show, :index]
  before_action :set_item, only: [:show, :update, :destroy]
  authorize_resource
  
  def index
    @active = Item.active.alphabetical.paginate(:page => params[:page]).per_page(10)
    @inactive = Item.inactive.alphabetical.paginate(:page => params[:page]).per_page(10)
    
  end

  def show
    @history = @item.item_prices.chronological
    @item_price = ItemPrice.new
    @similar_items = Item.active.for_category(@item.category)[1..3]
  end

  def edit
    @item = Item.find(params[:id])
    @item.item_prices.build  
  end

  def new
    @item = Item.new
    @item.item_prices.build
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to @item, notice: "#{@item.name} was added to the system."
    else
      render action: 'new'
    end
  end

  def update
    if @item.update(item_params)
      redirect_to @item, notice: "#{@item.name} was revised in the system."
    else
      render action: 'edit'
    end
  end

  def destroy
    @item.destroy
    redirect_to items_url, notice: "#{@item.name} was removed from the system."
  end

  def cart
    @order_items = get_list_of_items_in_cart
  end

  def add_to_cart
    @item = Item.find(params[:id])
    add_item_to_cart(@item.id)
    flash[:notice] = "Added #{@item.name} to the cart"
    redirect_to :back
  end

  def remove_from_cart
    @item = Item.find(params[:id])
    remove_item_from_cart(@item.id)
    flash[:notice] = "Removed #{@item.name} from the cart"
    redirect_to :back
  end

  private
  def set_item
    @item = Item.find(params[:id])
  end

  def item_params
    params.require(:item).permit(:active, :id, :name, :description, :category, :weight, :picture, :units_per_item, item_prices_attributes: [:id, :item_id, :price, :start_date, :end_date])
  end

end



