class Admin::BaseController < ApplicationController
  before_filter :authenticate_user_registration!
  before_filter :set_current_store
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

  def render_default_modal_form(title = nil, target = nil)
    @title = title
    target ||= "#{params[:controller]}/#{params[:action]}"
    render :partial => 'shared/default_modal_form', :locals => {:target => target}
  end

  def authorize_admin
    raise CanCan::AccessDenied unless current_user && current_user.has_role?('admin')
  end

end
