class WelcomeController < ApplicationController
  prepend_before_filter :set_widget
  before_filter :check_user, :only => [:comment, :rate]

  def comment
  end

  def rate

  end

  private
  def set_widget
    #URI.parse(env["REQUEST_URI"])

    reset_widget_session

    @current_widget = Widget.where(:key => session[:current_widget_key], :webpage => session[:current_widget_host]).first
    set_current_store(@current_widget.store)
  end

  def reset_widget_session
    if params["k"] && params["p"] && params["u"]
      session[:current_widget_host] = params["u"]
      session[:current_widget_key] = params["k"]
      session[:current_page] = params["p"]
    end
  end

  def init_session
    session[:current_widget_host] ||= request.referer
    session[:current_widget_key] ||= params[:k]
    if request.referer
      ref = URI.parse(request.referer)
      session[:current_page] ||= ref.path
    end
  end

  def check_user
    if @current_user.blank?
      if @current_anonymous_user.blank?
        ips = IpAddress.where(:value => request.remote_ip)
        if !ips.blank?
          ips.each do |ip|
            if ip.user.anonymous?
              @current_anonymous_user = ip.user
              session[:user_id] = ip.user.id
              break
            end
          end
          if @current_anonymous_user.blank?
            ip = IpAddress.create(:value => request.remote_ip)
            @current_anonymous_user = ip.user
            session[:user_id] = ip.user.id
          end
        else
          ip = IpAddress.create(:value => request.remote_ip)
          @current_anonymous_user = ip.user
          session[:user_id] = ip.user.id
        end
      end

    end
  end

  def load_comments
    @comments = @post.comments.main.order("#{::Comment.quoted_table_name}.created_at desc").page(params[:page]).per(5)
  end
end