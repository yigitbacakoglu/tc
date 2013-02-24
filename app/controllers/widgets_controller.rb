class WidgetsController < ApplicationController
  before_filter :load_widget

  def demo

  end

  def create
    if @current_user.present?

      obj = eval "#{params[:klass]}.find(#{params[:id]})"
      if params[:dimension].present?
        obj.rate params[:score].to_i, current_user.id, "#{params[:dimension]}"
      else
        obj.rate params[:score].to_i, current_user.id
      end

      render :json => true
    else
      render :json => false
    end
  end

  private

  def load_widget
    #URI.parse(env["REQUEST_URI"])
    @widget = Widget.where(:key => 1, :webpage => request.host.gsub("www.","")).first
    @post = @widget.posts.find_or_create_by_url(request.path)
  end

end
