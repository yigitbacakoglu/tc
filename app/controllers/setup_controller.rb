class SetupController < ApplicationController
  layout 'login'
  prepend_before_filter :set_current_store
  before_filter :authenticate_current_user, :except => :new


  def new
    unless current_user
      session["user_registration_return_to"] = setup_path(:step1)
      redirect_to new_user_registration_registration_path
    else
      redirect_to setup_path(:step1)
    end
  end

  def show
    case step
      when "step1"
        initialize_step1
      when "step2"
        initialize_step2
    end

    render step
  end

  def create
    case step
      when "step1"
        initialize_step1
      when "step2"
        save_step1
    end
    flash[:success] = "Congratulations! You successfully signed up"
    redirect_to edit_admin_widget_path(@widget)
  end

  private
  def step
    params[:id] || 'step1'
  end

  def initialize_step1
    @dont_show_signup_link = true
    @user_store = current_user.user_stores.new(:role => 'admin')
    @store = @user_store.build_store
    @widget = @store.widgets.build
  end

  def initialize_step2
    @dont_show_signup_link = true
    @widget = @current_store.widgets.first
  end


  def save_step1
    initialize_step1
    @widget.update_attributes(params[:widget])
    @store.update_attributes(params[:store])
    session[:store_id] = @store.id
    @current_user.update_attributes(params[:user])
  end

  def authenticate_current_user
    if current_user.blank?
      session["user_registration_return_to"] = setup_path(:step1)
      redirect_to new_user_registration_session_path
    end
  end
end




