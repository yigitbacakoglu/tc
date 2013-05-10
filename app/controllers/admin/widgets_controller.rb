class Admin::WidgetsController < Admin::BaseController


  def index
    @widgets = Widget.all
  end

  def new
    @widget = Widget.new
    @widget.widget_domains.build if @widget.widget_domains.blank?
  end

  def edit
    @widget = Widget.find(params[:id])
    @widget.widget_domains.build if @widget.widget_domains.blank?
  end

  def update
    @widget = Widget.find(params[:id])
    if @widget.update_attributes(params[:widget])
      redirect_to admin_widgets_path
    end
  end

  def delete_domain
    wd = WidgetDomain.find(params[:id])
    if wd.destroy
      respond_to do |format|
        flash[:success] = "Domain successfully removed"
        format.js { render "shared/destroy" }
      end
    end

  end

  def create
    @widget = Widget.new(params[:widget])
    @widget.store = @current_store
    if @widget.save
      flash[:success] = "Widget succesfully created"
      respond_to do |format|
        format.html { redirect_to edit_admin_widget_path(@widget) }
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