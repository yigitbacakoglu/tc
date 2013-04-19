class Admin::OverviewController < Admin::BaseController

  def index
    @comments = @current_store.comments.where("state != 'approved'").page(params[:page]).per(20)
  end

  def fire
    comment = @current_store.comments.where(:id => params[:comment_id]).first
    comment.send(params[:e])
    redirect_to admin_path
  end
end
