class Admin::WidgetsController < Admin::BaseController


  def index
    @widgets = Widget.all
  end

  def new
    @widget = Widget.new
  end

  def create
    @widget = Widget.new(params[:widget])
    @widget.key = SecureRandom.hex(15)
    if @widget.save
      flash[:success] = "Widget succesfully created"
      redirect_to admin_widgets_path
    end
  end
end