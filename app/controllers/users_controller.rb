class UsersController < ApplicationController

  def index
  end

  def show
  end

  def edit
  end

  def update
  end

  # GET /my/settings
  def settings
    @settings = current_user.preferences
  end

  # PUT /my/settings
  def settings_save
    settings = current_user.preferences

    respond_to do |format|
      if settings.update_attributes(params[:user_preference])
        format.html { redirect_to user_preferences_path(), :notice => :settings_updated }
        format.js   { flash.now[:notice] = :server_updated }
      else
        flash.now[:error] = settings.errors.full_messages
        format.html { render :action => "settings" }
        format.js
      end
    end
  end

end
