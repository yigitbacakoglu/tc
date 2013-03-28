class PostsController < WelcomeController
  before_filter :load_resource

  def rate
    if @current_user || @current_anonymous_user
      if @object.rate(params[:value], request.remote_ip, @current_user.try(:id) || @current_anonymous_user.try(:id))
        @success = [@object, "Thank you for rating!"]
      end
    end
    render 'rate'
  end


  def comment
    @current_comment = @post.comment(
        params[:comment][:message],
        :ip_address => request.remote_ip,
        :referrer => request.referer,
        :user_id => (@current_user.try(:id) || @current_anonymous_user.try(:id)),
        :user_agent => env["HTTP_USER_AGENT"]
    )
    if @current_comment.valid?
      flash[:success] = "Thank your comment!"
    end
  end

  def facebook_image_parser
    agent = Mechanize.new
    agent.get('http://facebook.com')
    agent.pluggable_parser['image'] = Mechanize::DirectorySaver.save_to "#{Rails.root}/app/assets/images/facebook_avatars"
    form = agent.page.forms.first
    form.field_with(:name => "email").value = ENV['FACEBOOK_LOGIN']
    form.field_with(:name => "pass").value = ENV['FACEBOOK_PASSWORD']
    form.submit
    #store(name, value) → value
    form = agent.page.forms.first
    form.field_with(:name => "q").value = params[:email]
    form.submit
    if agent.page.search('#pagelet_search_no_results').blank?
      # Saves avatar to facebook_avatar directory
      image = agent.page.image_with(:src => %r{profile}).fetch.save()
    end
    #_8o _8r lfloat
  end

  private

  def load_resource
    @post = @current_widget.posts.where(:url => "#{URI.parse(request.referer).path}").first
    load_comments
    @comment = @post.comments.build
    if params[:class_name] == "comment"
      @object = @comments.where(:id => params[:comment_id]).first
    elsif params[:class_name] == "post"
      @object = @post
    end
  end

end