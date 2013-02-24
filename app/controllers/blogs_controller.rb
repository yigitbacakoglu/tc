class BlogsController < ApplicationController
  layout "blog"

  def sale
    @sale = Sale.new
  end

  def save_contact_info
    if verify_recaptcha && Sale.create(params[:sale])
      @success = true
    else
      @error = "error"
    end
    respond_to do |format|
      format.js {render  :layout => false, :text => @error}
    end
  end
end
