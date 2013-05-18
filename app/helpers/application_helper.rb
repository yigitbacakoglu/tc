module ApplicationHelper

  def avatar_url(user)
    #TODO uploading avatar will be enabled.
    if false
      user.avatar_url
    else
      #default_url = "#{root_url}assets/avatar.png"
      default_url = "mm"
      gravatar_id = user.blank? ? "11" : Digest::MD5.hexdigest(user.email.downcase) rescue 11
      "http://gravatar.com/avatar/#{gravatar_id}?s=80&d=#{CGI.escape(default_url)}"
    end

  end

  def widget_params(starts_with = "&")
    "#{starts_with}u=#{session[:current_widget_host]}&k=#{session[:current_widget_key]}&p=#{session[:current_page]}"
  end
end
