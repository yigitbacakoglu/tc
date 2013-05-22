class Admin::BaseController < ApplicationController
  before_filter :authenticate_user_registration!
  before_filter :set_current_store
  before_filter :set_current_widget
  before_filter :authorize_admin

  layout "admin"

  def index

  end

  def update

  end

  def new

  end

  def create

  end

  def destroy

  end

  def set_current_widget
    if @current_store && @current_store.widgets.blank? && !params[:controller].eql?("admin/widgets")
      flash[:error] = "You should add at least one widget to use system !"
      redirect_to new_admin_widget_path
    end
    @current_widget = Widget.where(:id => session[:widget_id]).first
  end

  def render_default_modal_form(title = nil, target = nil)
    @title = title
    target ||= "#{params[:controller]}/#{params[:action]}"
    render :partial => 'shared/default_modal_form', :locals => {:target => target}
  end

  def authorize_admin
    raise CanCan::AccessDenied unless current_user && (current_user.has_role?('admin') || current_user.system_admin?)
    #session.delete(:current_widget_host)
    #session.delete(:current_widget_key)
    #session.delete(:current_page)
  end

  private
  def only_me
    if !current_user.system_admin? && !Rails.env.development?
      flash[:alert] = "How did you find there ? :)"
      redirect_to admin_path
    end
  end
end
