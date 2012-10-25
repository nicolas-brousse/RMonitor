class UsersController < ApplicationController
  before_filter :clean_param_id, :only => [:show, :edit, :update]
  load_and_authorize_resource

  # GET /users/:id
  def show
    @user = User.find(params[:id])
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/:id/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users/
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        format.html { redirect_to edit_user_path(@user), :notice => :user_created }
      else
        flash.now[:error] = @user.errors
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /users/:id
  def update
    @user = User.find(params[:id])
    params[:user].delete('password') && params[:user].delete('password_confirmation') if params[:user][:password].blank?

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to edit_user_path(@user), :notice => :account_updated }
        format.js   { flash.now[:notice] = :account_updated }
      else
        flash.now[:error] = @user.errors
        format.html { render :action => "edit" }
        format.js
      end
    end
  end

  # DELETE /users/:id
  # def destroy
  #   @user = User.find(params[:id])
  # end

  # GET /my/settings
  def settings
    @user     = current_user
    @settings = @user.preferences
  end

  # PUT /my/settings
  def settings_save
    user     = current_user
    user.assign_attributes(params[:user])
    user.preferences.assign_attributes(params[:user_preferences])

    respond_to do |format|
      if user.save
        format.html { redirect_to user_preferences_path(), :notice => :settings_updated }
        format.js   { flash.now[:notice] = :settings_updated }
      else
        flash.now[:error] = settings.errors
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
