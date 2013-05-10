class Admin::OverviewController < Admin::BaseController

  def index
    # Recent comments
    set_reports
    #UserMailer.password(User.last,3).deliver
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

  def set_session_widget
    if params[:widget_id]
      if params[:widget_id].eql?('-1')
        session.delete :widget_id
        redirect_to admin_path
      else
        @current_store.widget_ids.include?(params[:widget_id].to_i)
        session[:widget_id] = params[:widget_id]
        set_current_widget
        flash[:success] = "Successfully changed. You are managing Widget: '#{@current_widget.domains.first}'"
        redirect_to admin_path
      end
    end

  end

  def set_post
    @post = Post.find(params[:post_id])
    set_reports
  end

  def set_reports
    if @current_widget.blank?
      @posts = @current_store.widgets.collect { |w| w.posts }.first
    else
      @posts = @current_widget.posts
    end
    if @posts.blank?
      session.delete :widget_id
    end

    @post ||= @posts.first
    @comments = @post.comments.where("state = 'new'").page(params[:page]).per(5) if @post

    get_report_for_post(@post) if @post

  end

  def get_report_for_post(post)
    tmp_shares = []
    facebook_count = 0
    twitter_count = 0

    post.comments.collect { |c| tmp_shares += c.shares }

    @shares = post.shares.all + tmp_shares
    @shares.collect { |i| facebook_count +=1 if i.provider == 'facebook' }
    @shares.collect { |i| twitter_count +=1 if i.provider == 'twitter' }
    @facebook_count = facebook_count
    @twitter_count = twitter_count
    @shares_overall = (100 * @shares.count) / Share.all.count rescue 0

    tmp = 0
    post.comments.collect { |c| tmp += c.ratings.count }
    @visits = post.comments.count + post.ratings.count + tmp
    @visits_overall = (@visits * 100) /(Comment.all.count + Rating.all.count)  rescue 0

    @post_comments = post.comments
    @comments_overall = (@post_comments.count * 100) / Comment.all.count   rescue 0

    tmp_ratings = []
    post.comments.collect { |c| tmp_ratings += c.ratings }

    @ratings = @post.ratings.all + tmp_ratings
    @ratings_overall = @ratings.count * 100 / Rating.all.count  rescue 0
    like_count = 0
    dislike_count = 0

    @ratings.collect { |i| (i.value / i.max_value) > 0.5 ? like_count += 1 : dislike_count += 1 }
    @like_count = like_count
    @dislike_count = dislike_count
  end
end

# User can have multiple stores.
# why ?

# User can be admin of his own store ( His store : tatilarena.com , he creates widgets for tatilarena.com )
# User can be moderator of another store (Another store : tatilplanim.net)
# User can be admin of another store  (Another store : tatilplanim.net)
# I use store as master_widget to keep some general settings.
