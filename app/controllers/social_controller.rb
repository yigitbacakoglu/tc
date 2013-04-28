require 'twitter'
require 'fb_graph'
class SocialController < ApplicationController

  before_filter :set_session
  before_filter :set_message
  rescue_from FbGraph::InvalidRequest, :with => :oauth_facebook_error
  rescue_from FbGraph::InvalidToken, :with => :oauth_facebook_error
  rescue_from Twitter::Error::Unauthorized, :with => :oauth_twitter_error
  rescue_from Twitter::Error::Forbidden, :with => :duplicate_tweet

  def facebook
    session.delete :user_registration_return_to
    session[:user_registration_return_to] = request.fullpath

    if current_user.nil?
      respond_with_auth('facebook')
      #redirect_to '/user/auth/facebook'
    else
      fb_user = current_user.user_authentications.find_by_provider("facebook")
      if fb_user.nil?
        respond_with_auth('facebook')
        #redirect_to '/user/auth/facebook'
      else
        me = FbGraph::User.me(fb_user.oauth_token)

        unless me.permissions.include?(:publish_stream)
          respond_with_auth('facebook')
        else
          me.feed!(
              :message => @message,
              :link => @page
          )

          flash[:notice] = "Shared Successfully"
          respond_with_success
        end
      end
    end
  end

  def twitter
    session.delete :user_registration_return_to
    if current_user.nil?
      session[:user_registration_return_to] = request.fullpath
      respond_with_auth('twitter')
      #render :template => 'spree/promotions/auth' , :formats => [:js]
    else
      tw_user = current_user.user_authentications.find_by_provider("twitter")
      if tw_user.nil?
        session[:user_registration_return_to] = request.fullpath
        respond_with_auth('twitter')
        #render :template => 'spree/promotions/auth' , :formats => [:js]
      else
        Twitter.configure do |config|
          config.consumer_key = "9isVRy5mq4fyeN1jeeG65w"
          config.consumer_secret = "Yag3lZ6gToJTkUmrcZRNmuxcLbVIwUPjkVSdcLOw"
          config.oauth_token = tw_user.oauth_token
          config.oauth_token_secret = tw_user.oauth_token_secret

        end

        #TODO: twitter doesn't sent same message again but creating a random number is a temporary solution
        r = Random.new
        @message = "#{@message} #{@page} via @TalkyCloud #{r.rand(1...12341)}"
        Twitter.update(@message)

        flash[:notice] = "Shared successfully"
        respond_with_success
      end
    end
  end


  def set_params(provider)
    params[:href] = omniauth_authorize_path(:user, provider.to_sym, {display: "popup", state: request.protocol + request.env['HTTP_HOST'] + welcome_omniauth_path})
  end

  def oauth_facebook_error
    flash[:error] = "There's a problem on facebook connection, please logout and login back with facebook"
    respond_to do |format|
      format.html { redirect_to session[:return_to] }
      format.js { render 'error' }
    end
  end

  def oauth_twitter_error
    flash[:error] = "There's a problem on twitter connection, please logout and login back with twitter"
    respond_to do |format|
      format.html { redirect_to session[:return_to] }
      format.js { render 'error' }
    end
  end

  def duplicate_tweet
    flash[:notice] = "You already tweeted that!"
    respond_to do |format|
      format.html { redirect_to session["user_registration_return_to"] }
      format.js { render 'notice' }
    end
  end

  # promotions.js waits this response to open popup if needed.
  def respond_with_auth(provider)
    params[:href] = "/auth/#{provider}"
    respond_to do |format|
      format.js { render provider, :layout => false }
      format.html { render :template => 'social/auth' }
    end
  end

  def respond_with_success
    set_session
    respond_to do |format|
      format.js { render 'success' }
      format.html { redirect_to session["user_registration_return_to"] || admin_path }
    end
  end

  def set_session
    session["user_registration_return_to"] ||= "/close?" + "&p=#{session[:current_page]}&u=#{session[:current_widget_host]}&k=#{session[:current_widget_key]}"
  end

  def set_message
    if params[:comment_id]
      comment = Comment.where(:id => params[:comment_id]).first
      @message = comment.try(:message).truncate(30)
      username = comment.user.username
      @page = "http://#{comment.post.widget.webpage}#{comment.post.url}"
      @message = " \"#{@message}\" - #{username}"
    else
      post = Post.where(:id => params[:post_id]).first
      @page = "http://#{session[:current_widget_host]}#{session[:current_page]}"
      @message = "#{post.title}"
    end
  end
end