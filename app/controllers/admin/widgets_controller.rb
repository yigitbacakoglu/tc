class Admin::WidgetsController < Admin::BaseController


  def index
    @widgets = Widget.all
  end

  def new
    @widget = Widget.new
  end

  def edit
    @widget = Widget.find(params[:id])
  end

  def update
    @widget = Widget.find(params[:id])
    if @widget.update_attributes(params[:widget])
      redirect_to admin_widgets_path
    end
  end

  def create
    @widget = Widget.new(params[:widget])
    @widget.key = SecureRandom.hex(15)
    if @widget.save
      flash[:success] = "Widget succesfully created"
      respond_to do |format|
        format.html { redirect_to admin_widgets_path }
        format.js { render 'admin/widgets/create' }
      end
    end
  end

  def destroy
    widget = Widget.find(params[:id])
    if widget.destroy
      respond_to do |format|
        flash[:success] = "Widget successfully removed"
        format.js { render "shared/destroy" }
      end
    end
  end
end