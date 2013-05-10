class Admin::UsersController < Admin::BaseController

  respond_to :html, :js

  def new
    @user = User.new
    @user.build_user_registration
  end

  def index
    unless params[:e]
      @users = @current_store.users.page(params[:page]).per(25)
    else
      @users = @current_store.send("#{params[:e]}_users").page(params[:page]).per(25)
    end
  end

  def edit
    @user = @current_store.user_stores.where(:user_id => params[:id], :role => 'admin').first.try(:user)
    if @user.blank?
      flash[:error] = "Not found"
      redirect_to admin_users_path
    end
  end

  def update
    @user = @current_store.user_stores.where(:user_id => params[:id], :role => 'admin').first.try(:user)
    if @user.update_attributes(params[:user])
      redirect_to admin_users_path
    end
  end

  def create
    @user = User.new(params[:user])

    if @user.save
      UserStore.create(:store_id => @current_store.id, :user_id => @user.id, :role => 'admin')
      flash[:success] = "User succesfully created"
      respond_to do |format|
        format.html { redirect_to admin_users_path }
        format.js { render 'admin/users/create' }
      end
    else
      respond_with(@user)
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