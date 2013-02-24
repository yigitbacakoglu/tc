class ApplicationController < ActionController::Base
  protect_from_forgery
  include BaseHelper
  layout "application"
  prepend_before_filter :set_current_user
  before_filter :check_sale
  #before_filter :load_widget

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  private
  def set_current_user
    User.current = user_registration_signed_in? ? current_user_registration.user : nil
    @current_user = User.current
    save_ip_address
  end

  def save_ip_address
    if @current_user
      @current_user.ip_addresses.find_or_create_by_value(request.remote_ip)
    else
      a = IpAddress.find_or_create_by_value(request.remote_ip)
      @current_anonymous_user = a.user
    end
  end

  def check_sale
    for_sale = ["tinagold.com", "www.tinagold.com"]
    if for_sale.include?(request.host)
      redirect_to sale_path if (request.path != sale_path) && (save_contact_info_path != request.path)
    end
  end

  def load_widget
    #URI.parse(env["REQUEST_URI"])
    @widget = Widget.where(:key => 1, :webpage => request.host.gsub("www.", "")).first

    if params[:action] == 'demo'
      @post = @widget.posts.find_or_create_by_url(request.path)
      @comments = @post.comments.order("#{::Comment.quoted_table_name}.created_at desc").page(params[:page])

    else
      @post = @widget.posts.where(:url => "#{URI.parse(request.referer).path}").first
      @comments = @post.comments.order("#{::Comment.quoted_table_name}.created_at desc").page(params[:page])

    end


    if params[:class_name] == "comment"
      @object = @comments.where(:id => params[:id]).first
    elsif params[:class_name] == "post"
      @object = @post
    end

  #  ---
      @current_comment = Comment.find(params[:id])
      @post = @current_comment.post
      unless @widget.posts.include?(@post)
        redirect_to root_path
      end
      @comment = @post.comments.build
      #@comments = @post.comments.joins(:ratings).order("#{::Rating.quoted_table_name}.value desc")
      @comments = @post.comments.order("#{::Comment.quoted_table_name}.created_at desc").page(params[:page])
  end



end
