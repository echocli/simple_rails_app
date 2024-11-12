# https://api.rubyonrails.org/classes/ActionController/Base.html
class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]

  def index
    @users = UsersSearcher.new(params).search
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.reload
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @user.update(user_params)
      @user.reload
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    if @user.destroy
      @user.reload
    else
      render json: { error: "Failed to delete user" }, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  rescue Mongoid::Errors::DocumentNotFound
    render json: { error: "User not found" }, status: :not_found
  end

  def user_params
    params.permit(:name, :email)
  end
end
