class WidgetsController < WelcomeController
  before_filter :load_resource

  def demo
    #URI.parse(env["REQUEST_URI"])
    #session[:current_widget] = request.referer
    if @current_widget.login_required? && @current_user.blank?
      @user = UserRegistration.new_with_session({}, session)
      session["user_registration_return_to"] = "/close?" + "&p=#{session[:current_page]}&u=#{session[:current_widget_host]}&k=#{session[:current_widget_key]}"
    end
    @show_avatar = true
  end

  def close
    reset_widget_session
    flash.keep
    @show_avatar = true
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

  def load_resource
    @post = @current_widget.posts.find_or_create_by_url(session[:current_page])
    @comment = @post.comments.build
    load_comments
  end

end
