# app/controllers/users_controller.rb
class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]

  # GET /users
  def index
    users_searcher = UsersSearcher.new(params)
    @users = users_searcher.call
    render :index  # Renders app/views/users/index.json.jbuilder
  end

  # GET /users/:id
  def show
    render :show # Renders app/views/users/show.json.jbuilder
  end

  # POST /users
  def create
    @user = User.new(user_params)
    if @user.save
      render :create, status: :created # Renders app/views/users/create.json.jbuilder
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/:id
  def update
    if @user.update(user_params)
      render :update, status: :ok # Renders app/views/users/update.json.jbuilder
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /users/:id
  def destroy
    @user.destroy
    render :destroy, status: :ok # Renders app/views/users/destroy.json.jbuilder
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  rescue Mongoid::Errors::DocumentNotFound
    render json: { error: "User not found" }, status: :not_found
  end

  # Only allow a trusted parameter "white list" through.
  def user_params
    params.require(:user).permit(:name, :email, :age)
  end
end
