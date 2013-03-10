class CommentsController < WelcomeController
  before_filter :load_resource


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
    render 'posts/rate'
  end

  private

  def load_resource
    @current_comment = Comment.find(params[:id])
    @post = @current_comment.post
    unless @current_widget.posts.include?(@post)
      redirect_to root_path
    end
    @comment = @post.comments.build
    #@comments = @post.comments.joins(:ratings).order("#{::Rating.quoted_table_name}.value desc")
    load_comments
  end
end