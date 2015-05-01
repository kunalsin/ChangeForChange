class ItemsController < ApplicationController


  before_action :check_login, except: [:show, :index]
  before_action :set_item, only: [:show, :update, :destroy]
  authorize_resource
  
  def index
    @active = Item.active.alphabetical.paginate(:page => params[:page]).per_page(10)
    @inactive = Item.inactive.alphabetical.paginate(:page => params[:page]).per_page(10)
  end

  def show
    @history = @item.item_prices.chronological
  end

  def new
    @item = Item.new
    @item.item_prices.build
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      @item.item_prices.set_end_date.save!
      redirect_to @item, notice: "Thank you, #{@item.name} was added."
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
    redirect_to items_url, notice: "This item was removed from the system."
  end

  private
  def set_item
    @item = Item.find(params[:id])
  end

  def item_params
    params.require(:item).permit(:active, :id, :name, :description, :picture, :category, :weight, :photo, :units_per_item, item_prices_attributes: [:id, :price, :start_date, :end_date])
  end

end



