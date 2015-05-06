class UsersController < ApplicationController
  include ActionView::Helpers::NumberHelper
  include BreadExpressHelpers::Cart

  before_action :check_login, except: [:new, :create]
  before_action :set_customer, only: [:show, :edit, :update, :destroy]
  authorize_resource
  
  def index
    @active_customers = Customer.active.alphabetical.paginate(:page => params[:page]).per_page(10)
    @inactive_customers = Customer.inactive.alphabetical.paginate(:page => params[:page]).per_page(10)
  end

  def show
    @previous_orders = @customer.orders.chronological
  end

  def new
    @customer = Customer.new
    user = @customer.build_user
  end

  def edit
    # reformat phone w/ dashes when displayed for editing (preference; not required)
    @customer.phone = number_to_phone(@customer.phone)
    # should have a user associated with customer, but just in case...
    user = @customer.build_user
  end

  def create
    @customer = Customer.new(customer_params)
    if @customer.save
      if !current_user
        session[:user_id] = @customer.user.id
      end
      create_cart
      redirect_to @customer, notice: "#{@customer.proper_name} was added to the system."
    else
      render action: 'new'
    end
  end

  def update
    # just in case customer trying to hack the http request...
    reset_username_param unless current_user.role? :admin
    if @customer.update(customer_params)
      redirect_to @customer, notice: "#{@customer.proper_name} was revised in the system."
    else
      render action: 'edit'
    end
  end

  def destroy
    @customer.destroy
    redirect_to customers_url, notice: "The customer was removed from the system."
  end

  private
  def set_customer
    @customer = Customer.find(params[:id])
  end

  def customer_params
    reset_role_param unless current_user.role? :admin
    params.require(:customer).permit(:first_name, :last_name, :email, :phone, :active)
  end

  def reset_role_param
    params[:customer][:user_attributes][:role] = "customer"
  end

  def reset_username_param
    params[:customer][:user_attributes][:username] = @customer.user.username
  end
end