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
    @current_widget = Widget.where(:key => 1, :webpage => request.host.gsub("www.", "")).first
    #@current_widget = Widget.where(:key => params[:key], :webpage => request.host.gsub("www.", "")).first
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