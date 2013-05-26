class Admin::SettingsController < Admin::BaseController


  def index
    @restrictions = @current_store.restrictions.page(params[:page]).per(25)
  end


  def update
    update_restricted_words
    flash[:success] = t(:updated_successfuly)
    redirect_to admin_settings_path
  end

  def update_restricted_words
    old_restricted_words = @current_store.restricted_words.map(&:value)
    new_restricted_words = params[:restricted_words].each(&:strip)

    # Words that are removed from list
    will_deleted_words = (old_restricted_words - new_restricted_words)

    #Words that are added to list
    will_added_words = (new_restricted_words - old_restricted_words)

    @current_store.delete_words(will_deleted_words)
    @current_store.add_words(will_added_words)
  end
end