class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user

    if user.has_role? :admin
      can :manage, :all
    else
      can :read, :all
      can :close, Widget
      can :demo, Widget
      can :create, Comment
      can :create, Rating
      can :update, Rating
      can :comment, Post
      can :rate, Post
      can :rate, Comment

      can :update, Comment do |comment|
        comment.try(:user) == user || user.has_role?(:moderator)
      end
      can :destroy, Comment do |comment|
        comment.try(:user) == user || user.has_role?(:moderator)
      end
    end
  end
end
