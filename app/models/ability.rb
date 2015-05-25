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

      can :manage, :all

    elsif user.role? :shipper

      # they can read their own profile
      can :show, User do |c|  
        c.id = user.id
      end

    elsif user.role? :baker

      # they can read their own profile
      can :show, User do |c|  
        c.id = user.id
      end

    else
      # guests can read items covered (plus home pages)
      # and create a customer account
      can :read, Item
      can :create, Customer
    end
  end
end
