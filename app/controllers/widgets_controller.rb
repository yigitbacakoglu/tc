class WidgetsController < WelcomeController
  before_filter :load_widget

  def demo
    if @current_widget.login_required? && @current_user.blank?
      @user = UserRegistration.new_with_session({}, session)
      session["user_registration_return_to"] = request.path
    end
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
    @post = @current_widget.posts.find_or_create_by_url(request.path)
    @comment = @post.comments.build
    @comments = @post.comments.order("#{::Comment.quoted_table_name}.created_at desc")
  end

end
