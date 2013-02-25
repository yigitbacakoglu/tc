class CommentsController < WelcomeController

  before_filter :load_widget

  def edit

  end

  def update
    if @current_user || @current_anonymous_user
      if @current_comment.update_attributes(params[:comment])
        flash[:success] = "Thank you for comment!"
      end
    end
  end

  def destroy
    if @current_user || @current_anonymous_user
      if @current_comment.destroy
        flash[:success] = "Deleted"
      end
    end
  end

  private
  def load_widget
    #URI.parse(env["REQUEST_URI"])
    @widget = Widget.where(:key => 1, :webpage => request.host.gsub("www.", "")).first
    @current_comment = Comment.find(params[:id])
    @post = @current_comment.post
    unless @widget.posts.include?(@post)
      redirect_to root_path
    end
    @comment = @post.comments.build
    #@comments = @post.comments.joins(:ratings).order("#{::Rating.quoted_table_name}.value desc")
    @comments = @post.comments.order("#{::Comment.quoted_table_name}.created_at desc")
  end
end