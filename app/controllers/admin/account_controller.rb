module Admin
  class AccountController < Admin::BaseController
    before_filter :load_resource

    def update

      if params[:new_password] # When user sign_ups with facebook, he has not password. He need to define password before removing facebook auth method
        if params[:user_registration][:password].present? && @user.update_attributes(params[:user_registration])
          # this logic needed b/c devise wants to log us out after password changes
          user_registration = UserRegistration.reset_password_by_token(params[:user_registration])
          #UserRegistrationMailer.new_password_information(user_registration).deliver
          sign_in(@user, :event => :authentication, :bypass => true)
          flash[:notice] = t('devise.passwords.can_delete_social')
          respond_to do |format|
            format.html { redirect_to admin_account_url }
            format.js { render :text => 'document.location.reload();' }
          end
        else
          #  render error message
          flash[:error] = t(:enter_password) if params[:user_registration][:password].blank?
        end
      else
        if @user_registration.update_attributes(params[:user_registration])
          if params[:user_registration][:password].present?
            # this logic needed b/c devise wants to log us out after password changes
            user_registration = UserRegistration.reset_password_by_token(params[:user_registration])
            #UserRegistrationMailer.new_password_information(user_registration).deliver
            sign_in(@user_registration, :event => :authentication, :bypass => true)
          end
          redirect_to admin_account_url, :notice => t(:account_updated)
        else
          @user_registration.errors.to_a.each do |error|
            flash[:error] = "#{error}"
          end
          render "show"
        end
      end

    end

    private

    def load_resource
      @user_registration = current_user_registration
    end
  end
end
