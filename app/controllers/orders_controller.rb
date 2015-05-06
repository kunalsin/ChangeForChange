class OrdersController < ApplicationController
  include BreadExpressHelpers::Cart
  include BreadExpressHelpers::Shipping


  before_action :check_login
  before_action :set_order, only: [:show, :update, :destroy]
  authorize_resource
  
  def index
    if logged_in? && !current_user.role?(:customer)
      @pending_orders = Order.not_shipped.chronological.paginate(:page => params[:page]).per_page(5)
      @all_orders = Order.chronological.paginate(:page => params[:page]).per_page(5)
    else
      @pending_orders = current_user.customer.orders.not_shipped.chronological.paginate(:page => params[:page]).per_page(5)
      @all_orders = current_user.customer.orders.chronological.paginate(:page => params[:page]).per_page(5)
    end 
  end

  def show
    @order_items = @order.order_items.to_a
    if current_user.role?(:customer)
      @previous_orders = current_user.customer.orders.chronological.to_a
    else
      @previous_orders = @order.customer.orders.chronological.to_a
    end
  end

  def new
    @order = Order.new
    @cart = get_list_of_items_in_cart
    @total = calculate_cart_items_cost
    @shipping = calculate_cart_shipping
    @grand_total = @total + @shipping
  end 

  def create
    @order = Order.new(order_params)
    @order.customer_id = current_user.customer.id
    @order.date = Date.today
    @cart = get_list_of_items_in_cart
    @total = calculate_cart_items_cost
    @shipping = calculate_cart_shipping
    @grand_total = @total + @shipping
    @order.grand_total = @grand_total
    if @order.save
      save_each_item_in_cart(@order)
      @order.pay
      clear_cart
      redirect_to @order, notice: "Thank you for ordering from Bread Express."
    else
      render action: 'new'
    end
  end

  def update
    if @order.update(order_params)
      redirect_to @order, notice: "Your order was revised in the system."
    else
      render action: 'edit'
    end
  end

  def destroy
    @order.destroy
    redirect_to orders_url, notice: "This order was removed from the system."
  end

  private
  def set_order
    @order = Order.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:address_id, :customer_id, :date, :grand_total, :credit_card_number, :expiration_month, :expiration_year)
  end

end