class Admin::UsersController < Admin::BaseController


  def index
    unless params[:e]
      @users = @current_store.users.page(params[:page]).per(25)
    else
      @users = @current_store.send("#{params[:e]}_users").page(params[:page]).per(25)
    end
  end

  def ban
    UserStore.where(:store_id => @current_store.id,
                    :user_id => params[:id]).first.ban!

    flash[:success] = "User is banned from your webpages!"
  end

  def allow
    UserStore.where(:store_id => @current_store.id,
                    :user_id => params[:id]).first.allow!

    flash[:success] = "User is allowed for your webpages!"
    render :text => "document.location.reload();"
  end
end