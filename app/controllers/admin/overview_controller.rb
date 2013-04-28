class Admin::OverviewController < Admin::BaseController

  def index
    # Recent comments
    @comments = @current_store.comments.where("state = 'new'").page(params[:page]).per(5)
  end

  def fire
    comment = @current_store.comments.where(:id => params[:comment_id]).first
    comment.send(params[:e])
    redirect_to admin_path
  end
end
