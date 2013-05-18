class UserRegistrationsController < Devise::RegistrationsController
  layout "login"
  prepend_before_filter :set_user_session
  # POST /resource
  def create
    build_resource

    if resource.save
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up
        sign_up(resource_name, resource)
        if request.referer.include?('demo') && params[:close].eql?('true')
          session["user_registration_return_to"] ||= request.referer
        elsif params[:close].eql?('false')
          #resource.update_attributes(:role => 'admin')
          session["user_registration_return_to"] = request.referer
        end
        respond_with resource, :location => after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
        expire_session_data_after_sign_in!
        respond_with resource, :location => after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      if request.referer.include?('demo') && params[:close] == "false"
        render :partial => "shared/errors", :locals => {:target => resource}, :formats => [:js]
      else
        respond_with resource
      end
    end
  end

  private

  def build_resource(*args)
    super
    if session[:omniauth]
      auth_hash = session[:omniauth]
      @user_registration.apply_omniauth(session[:omniauth])
      @user_registration.check_username(auth_hash['info']['nickname'])
      @user_registration.build_user(:firstname => auth_hash['info']['first_name'].try(:strip), :lastname => auth_hash['info']['last_name'])
      @user_registration.valid?
    end
  end


  def set_user_session
    if !params["k"].blank? && !params["p"].blank? && !params["u"].blank?
      session["user_registration_return_to"] = "/close?" + "&p=#{params[:p]}&u=#{session[:current_widget_host]}&k=#{params[:k]}"
    elsif params[:close] == "false"
      session.delete "user_registration_return_to"
    end
  end
end
