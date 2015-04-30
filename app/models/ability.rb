class Ability
  include CanCan::Ability
  
  
  def initialize(user)
    # set user to new User if not logged in
    user ||= User.new # i.e., a guest user

  # set authorizations for different user roles
    if user.role? :admin
      # they get to do it all
      can :manage, :all
      
    elsif user.role? :customer

      # they can read their own profile
      can :show, Customer do |u|  
        u.id == user.customer.id
      end
      # they can update/edit their own profile
      can :update, Customer do |u|  
        u.id == user.customer.id
      end

      # they can read items in their orders
      can :read, Order do |this_order|  
        order_items = user.customer.orders.map{|p| p.id.map(&:id)}
        order_items.include? this_order.id 
      end

      #can see a list of all the items
      can :index, Item

      can :create, Address    
     
      # they can update tasks in these projects
      can :update, Address do |this_address|  
        my_address = user.customer.address.map{|p| p.id.map(&:id)}
        my_address.include? this_address.id 
      end

    else
      # guests can read items covered (plus home pages)
      # and create a customer account
      can :read, Item
      can :create, Customer
    end
  end
end
