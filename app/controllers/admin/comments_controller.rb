class Admin::CommentsController < Admin::BaseController


  def index
    params[:state] ||= ['approved', 'rejected', 'new']
    if params[:state] =='agreed'
      @comments = Kaminari.paginate_array(@current_store.comments.sort_by { |c| c.percentage_avg_rate }.last(5)).page(params[:page]).per(25)
    elsif params[:state] == 'disagreed'
      @comments = Kaminari.paginate_array(@current_store.comments.collect { |x| x if x.percentage_avg_rate > 0 && x.percentage_avg_rate < 0.36 }.delete_if(&:blank?).sort_by { |c| c.percentage_avg_rate }.first(5)).page(params[:page]).per(25)
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
      flash[:success] = "Updated succesfully!"
    else
      flash[:error] = "Something went wrong!"
    end
    redirect_to session[:comment_return_to]
  end

  def set_all
    @comments = @current_store.comments.where("state != 'approved'").collect { |c| c.send("#{params[:state]}!") }
    redirect_to admin_path
  end
end