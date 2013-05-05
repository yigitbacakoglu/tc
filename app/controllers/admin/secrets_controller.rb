class Admin::SecretsController < Admin::BaseController
  before_filter :only_me
  # GET /admin/secrets
  # GET /admin/secrets.json
  def index
    @secrets = Secret.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @secrets }
    end
  end

  # GET /admin/secrets/1
  # GET /admin/secrets/1.json
  def show
    @secret = Secret.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @secret }
    end
  end

  # GET /admin/secrets/new
  # GET /admin/secrets/new.json
  def new
    @secret = Secret.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @secret }
    end
  end

  # GET /admin/secrets/1/edit
  def edit
    @secret = Secret.find(params[:id])
  end

  # POST /admin/secrets
  # POST /admin/secrets.json
  def create
    @secret = Secret.new(params[:secret])

    respond_to do |format|
      if @secret.save
        format.html { redirect_to admin_secrets_path, notice: 'Secret was successfully created.' }
        format.json { render json: @secret, status: :created, location: @secret }
      else
        format.html { render action: "new" }
        format.json { render json: @secret.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /admin/secrets/1
  # PUT /admin/secrets/1.json
  def update
    @secret = Secret.find(params[:id])

    respond_to do |format|
      if @secret.update_attributes(params[:secret])
        format.html { redirect_to admin_secrets_path, notice: 'Secret was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @secret.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/secrets/1
  # DELETE /admin/secrets/1.json
  def destroy
    @secret = Secret.find(params[:id])
    @secret.destroy

    respond_to do |format|
      format.html { redirect_to admin_secrets_url }
      format.json { head :no_content }
    end
  end

  private
  def only_me

    unless ["ycbacakoglu@gmail.com, yigitcan_bacakoglu@hotmail.com"].include?(current_user.email)
      flash[:alert] = "How did you find there ? :)"
      redirect_to admin_path
    end
  end

end

