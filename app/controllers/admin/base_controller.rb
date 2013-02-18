class Admin::BaseController < ApplicationController
  before_filter :authenticate_user_registration!
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

end
