class CommentsController < WelcomeController
  load_and_authorize_resource
  before_filter :load_resource

  def edit
    @show_avatar = false;
  end

  def update
    if @current_user || @current_anonymous_user
      if @current_comment.update_attributes(params[:comment])
        flash[:success] = t(:thanks_for_comment)
      end
    end
  end

  def destroy
    if @current_user || @current_anonymous_user
      if @current_comment.destroy
        flash[:notice] = t(:comment_deleted)
      end
    end
    render 'shared/destroy'
  end

  private

  def load_resource
    @current_comment = @comment
    @post = @current_comment.post
    unless @current_widget.posts.include?(@post)
      redirect_to root_path
    end
    @comment = @post.comments.build
    #@comments = @post.comments.joins(:ratings).order("#{::Rating.quoted_table_name}.value desc")
    load_comments
  end
end