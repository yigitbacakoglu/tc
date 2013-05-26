class Admin::CommentsController < Admin::BaseController


  def index
    params[:state] ||= ['approved', 'rejected', 'new']
    if params[:state] =='agreed'
      @comments = Kaminari.paginate_array(@current_store.comments.collect { |x| x if x.percentage_avg_rate >= 0.51 }.delete_if(&:blank?).sort_by { |c| c.percentage_avg_rate }.last(5)).page(params[:page]).per(25)
    elsif params[:state] == 'disagreed'
      @comments = Kaminari.paginate_array(@current_store.comments.collect { |x| x if x.percentage_avg_rate > 0 && x.percentage_avg_rate < 0.51 }.delete_if(&:blank?).sort_by { |c| c.percentage_avg_rate }.first(5)).page(params[:page]).per(25)
    elsif params[:state] == "flagged"
      @comments = Comment.joins(:flags).where("#{CommentFlag.table_name}.comment_id IN(?)", @current_store.comment_ids).page(params[:page]).per(25)
    else
      @comments = @current_store.comments.where(:state => params[:state]).page(params[:page]).per(25)
    end
  end


  def fire
    comment = @current_store.comments.where(:id => params[:comment_id]).first
    comment.send(params[:e])
    redirect_to admin_comments_path
  end

  def show
    @comment = Comment.find(params[:id])
    @shares = @comment.shares
    @facebook_count = @shares.where(:provider => "facebook").count
    @twitter_count = @shares.where(:provider => "twitter").count
    @shares_overall = (100 * @shares.count) / Share.all.count rescue 0
    @ratings = @comment.ratings
    @ratings_overall = (100 * @ratings.count) / Rating.all.count rescue 0
    @children = @comment.children
    @children_overall = (100 * @children.count) / Comment.where("parent_id IS NOT NULL").count rescue 0

    @flags = @comment.flags
    @flags_overall = (100 * @flags.count) / CommentFlag.where(:comment_id => @comment.post.comment_ids).count rescue 0

  end


  def edit
    @comment = Comment.find(params[:id])
    session[:comment_return_to] = request.referer
    respond_to do |format|
      format.html { render :layout => !request.xhr? }
      format.js { render_default_modal_form("Edit Comment") }
    end
  end

  def update
    comment = Comment.find(params[:id])
    if comment.update_attributes(params[:comment])
      flash[:success] = t(:updated_successfuly)
    else
      flash[:error] = t(:something_went_wrong)
    end
    redirect_to session[:comment_return_to]
  end

  def set_all
    @comments = @current_store.comments.where("state != 'approved'").collect { |c| c.send("#{params[:state]}!") }
    redirect_to admin_path
  end
end