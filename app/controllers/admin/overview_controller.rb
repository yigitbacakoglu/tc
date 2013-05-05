class Admin::OverviewController < Admin::BaseController

  def index
    # Recent comments
    @comments = @current_store.comments.where("state = 'new'").page(params[:page]).per(5)
    @shares = Share.all
    UserMailer.password(User.last,3).deliver
  end

  def fire
    comment = @current_store.comments.where(:id => params[:comment_id]).first
    comment.send(params[:e])
    redirect_to admin_path
  end

  #Allows user to switch stores
  def set_session_store
    if params[:store_id]
      validate = current_user.user_stores.where(:store_id => params[:store_id], :role => 'admin')
      if !validate.blank?
        session[:store_id] = params[:store_id]
        set_current_store
        flash[:success] = "Successfully changed. You are managing Site: '#{@current_store.name}'"
      end
    end
    redirect_to admin_path
  end
end

# User can have multiple stores.
# why ?

# User can be admin of his own store ( His store : tatilarena.com , he creates widgets for tatilarena.com )
# User can be moderator of another store (Another store : tatilplanim.net)
# User can be admin of another store  (Another store : tatilplanim.net)
# I use store as master_widget to keep some general settings.
