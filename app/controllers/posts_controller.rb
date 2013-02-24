class PostsController < ApplicationController
  before_filter :load_widget

  def rate
    if @current_user || @current_anonymous_user
      if @object.rate(params[:value], request.remote_ip)
        @success = [@object, "Thank you for rating!"]
      end
    end
    render 'rate'
  end

  def comment
    if @current_user || @current_anonymous_user
      if @post.comment(params[:comment][:message], request.remote_ip, nil)
        flash[:success] = "Thank you for rating!"
      end
    end
    render 'rate'
  end

  private

  def load_widget
    #URI.parse(env["REQUEST_URI"])
    @widget = Widget.where(:key => 1, :webpage => request.host).first
    @post = @widget.posts.where(:url => "#{URI.parse(request.referer).path}").first
    @comments = @post.comments.order("#{::Comment.quoted_table_name}.created_at desc")
    @comment = @post.comments.build

    if params[:class_name] == "comment"
      @object = @comments.where(:id => params[:id]).first
    elsif params[:class_name] == "post"
      @object = @post
    end
  end

end