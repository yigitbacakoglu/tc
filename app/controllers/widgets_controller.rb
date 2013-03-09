class WidgetsController < WelcomeController

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
    @widget = Widget.where(:key => 1, :webpage => request.host.gsub("www.", "")).first
    @post = @widget.posts.find_or_create_by_url(request.path)
    @comment = @post.comments.build
    @comments = @post.comments.order("#{::Comment.quoted_table_name}.created_at desc")
  end

end
