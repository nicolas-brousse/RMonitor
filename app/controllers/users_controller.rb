class UsersController < ApplicationController

  # GET /servers/:id
  def show
    if params[:id] == 'my'
      @user = current_user
    else
      @user = User.find(params[:id])
    end
  end

  # GET /servers/new
  def new
    @user = User.new
  end

  # GET /servers/:id/edit
  def edit
    if params[:id] == 'my'
      @user = current_user
    else
      @user = User.find(params[:id])
    end
  end

  # POST /servers/
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        format.html { redirect_to edit_user_path(@user), :notice => :user_created }
      else
        flash.now[:error] = @user.errors.full_messages
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /servers/:id
  def update
    if params[:id] == 'my'
      @user = current_user
    else
      @user = User.find(params[:id])
    end

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to edit_user_path(@user), :notice => :user_updated }
        format.js   { flash.now[:notice] = :user_updated }
      else
        flash.now[:error] = @user.errors.full_messages
        format.html { render :action => "edit" }
        format.js
      end
    end
  end

  # DELETE /servers/:id
  # def destroy
  #   @user = User.find(params[:id])
  # end

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
