class Ability
  include CanCan::Ability
  include BreadExpressHelpers::Baking
  include BreadExpressHelpers::Shipping
  include BreadExpressHelpers::Cart

  def initialize(user)
    # set user to new User if not logged in
    user ||= User.new # i.e., a guest user

  # set authorizations for different user roles
    if user.role? :admin
      # they get to do it all
      can :manage, :all
      
    elsif user.role? :customer

      # they can read their own profile
      can :show, Customer do |c|  
        c.id == user.customer.id
      end

      # they can update/edit their own profile
      can :update, Customer do |c|  
        c.id == user.customer.id
      end

      # they can update/edit their own profile
      can :edit, Customer do |c|  
        c.id == user.customer.id
      end

      can :show, User do |c|  
        c.id = user.id
      end

      # they can read their own profile
      can :edit, User do |c|  
        c.id = user.id
      end

      can :update, User do |c|  
        c.id = user.id
      end

      # they can read items in their orders
      can :read, Order do |this_order|  
        order_items = user.customer.orders.map(&:id)
        order_items.include? this_order.id 
      end

      # they can create a new order by checking-out
      can :create, Order
      # they can add items to their cart
      can :add_to_cart, Item
      # they can remove items from their cart
      can :remove_from_cart, Item

      #can see a list of all the items
      can :index, Item
      #can view their cart
      can :cart, Item
      #can create new addresses
      can :create, Address
     
      # they can update addresses for themselves
      can :update, Address do |this_address|  
        my_address = user.customer.addresses.map(&:id)
        my_address.include? this_address.id 
      end
      # they can edit their own addresses
      can :edit, Address do |this_address|  
        my_address = user.customer.addresses.map{|p| p.id}
        my_address.include? this_address.id 
      end

      # they can read their address
      can :read, Address do |this_address|  
        my_address = user.customer.address.map(&:id)
        my_address.include? this_address.id 
      end

    elsif user.role? :shipper

      can :read, Item

    elsif user.role? :baker

      can :read, Item

    else
      # guests can read items covered (plus home pages)
      # and create a customer account
      can :read, Item
      can :create, Customer
    end
  end
end
