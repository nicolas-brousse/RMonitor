class UsersController < ApplicationController
  before_filter :clean_param_id, :only => [:show, :edit, :update]
  load_and_authorize_resource

  # GET /servers/:id
  def show
    @user = User.find(params[:id])
  end

  # GET /servers/new
  def new
    @user = User.new
  end

  # GET /servers/:id/edit
  def edit
    @user = User.find(params[:id])
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
    @user = User.find(params[:id])
    params[:user].delete('password') && params[:user].delete('password_confirmation') if params[:user][:password].blank?

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

private
  def clean_param_id
    params[:id] = current_user.id if params[:id] == "my"
  end
end
