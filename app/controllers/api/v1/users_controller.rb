class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]

  # GET /users
  def index
    users_searcher = UsersSearcher.new(params)
    @users = users_searcher.search
    # Automatically renders app/views/users/index.json.jbuilder
  end

  # GET /users/:id
  def show
    # Automatically renders app/views/users/show.json.jbuilder
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      # Automatically renders app/views/users/create.json.jbuilder
      render :show, status: :created
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/:id
  def update
    if @user.update(user_params)
      # Automatically renders app/views/users/update.json.jbuilder
      render :show, status: :ok
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /users/:id
  def destroy
    @user.destroy
    # Automatically renders app/views/users/destroy.json.jbuilder
    head :no_content # Just return an empty response with 204 status
  end

  private

  # Set user for show, update, and destroy actions
  def set_user
    @user = User.find(params[:id])
  rescue Mongoid::Errors::DocumentNotFound
    render json: { error: "User not found" }, status: :not_found
  end

  # Permit only the allowed parameters
  def user_params
    params.require(:user).permit(:name, :email)
  end
end