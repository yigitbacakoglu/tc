class HomeController < ApplicationController
  before_filter :check_sale

  def index

  end

  private

  def check_sale
    for_sale = ["tinagold.com"]
    if for_sale.include?(request.host)
      redirect_to sale_path
    end
  end
end
