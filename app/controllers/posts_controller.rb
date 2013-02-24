class PostsController < ApplicationController
  before_filter :load_widget

  def rate
    if @current_user || @current_anonymous_user
      if @post.rate(params[:value], request.remote_ip )
        flash[:success] = "Thank you for rating!"
      end
    end
    render 'rate'
  end

  def comment
    if @sub_comment

    else

    end
  end

  private

  def load_widget
    #URI.parse(env["REQUEST_URI"])
    @widget = Widget.where(:key => 1, :webpage => request.host).first
    @post = @widget.posts.where(:url => "#{URI.parse(request.referer).path}").first
  end

end