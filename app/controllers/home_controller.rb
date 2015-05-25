class HomeController < ApplicationController
  include BreadExpressHelpers::Baking
  include BreadExpressHelpers::Shipping
  include BreadExpressHelpers::Cart

  def home
  	@breads = create_baking_list_for('bread')
  	@muffins = create_baking_list_for('muffins')
  	@pastries = create_baking_list_for('pastries')
  	@unshipped_orders = Order.not_shipped.chronological.paginate(:page => params[:page]).per_page(5)
    @total_c = total_customers
    @total_u = total_users
    @total_i = total_items
  end

  def about
  end

  def privacy
  end

  def contact
  end

  def mark_shipped
    @order_items = OrderItem.find(params[:id])
    @order_items.shipped_on = Date.today
    @order_items.save!
    redirect_to home_path
  end

  def mark_unshipped
    @order_items = OrderItem.find(params[:id])
    @order_items.shipped_on = nil
    @order_items.save!
    redirect_to home_path
  end

  def total_customers
    @total_cust = Customer.getAll().count
  end

  def total_users
    @total_users = User.all.count
  end

  def total_items
    @total_items = Item.all.count
  end
end