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
    if params[:action] == 'demo'
      session[:current_widget_host] ||= request.referer
      session[:current_widget_key] ||= params[:k]
      if !params[:k].blank? && params[:k] != session[:current_widget_key]
        reset_widget_session
      end
    end
    uri = URI.parse(session[:current_widget_host])
    #keys=CGI::parse(uri.query)

    if request.referer
      ref = URI.parse(request.referer)
      session[:current_page] ||= ref.path
    end
    @current_widget = Widget.where(:key => 123, :webpage => request.host.gsub("www.", "")).first
    #@current_widget = Widget.where(:key => params[:key], :webpage => request.host.gsub("www.", "")).first
  end

  def reset_widget_session
    session[:current_widget_host] = request.referer
    session[:current_widget_key] = params[:k]
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
        else
          ip = IpAddress.create(:value => request.remote_ip)
          @current_anonymous_user = ip.user
          session[:user_id] = ip.user.id
        end
      end

    end
  end

  def load_comments
    @comments = @post.comments.order("#{::Comment.quoted_table_name}.created_at desc").page(params[:page]).per(5)
  end
end