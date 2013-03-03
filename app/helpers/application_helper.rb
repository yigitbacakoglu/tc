module ApplicationHelper

  def avatar_url(user)
    #TODO uploading avatar will be enabled.
    if false
      user.avatar_url
    else
      #default_url = "#{root_url}assets/avatar.png"
      default_url = "mm"
      gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
      "http://gravatar.com/avatar/#{gravatar_id}?s=80&d=#{CGI.escape(default_url)}"
    end

  end
end
