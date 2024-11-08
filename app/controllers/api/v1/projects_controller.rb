class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :update, :destroy, :assign_user, :change_status]

  # GET /projects
  def index
    @projects = ProjectsSearcher.new(params).call
    render json: @projects
  end

  # GET /projects/:id
  def show
    render json: @project
  end

  # POST /projects
  def create
    @project = Project.new(project_params)

    if @project.save
      render json: @project, status: :created, location: @project
    else
      render json: @project.errors, status: :unprocessable_entity
    end
  end

  # PUT /projects/:id
  def update
    if @project.update(project_params)
      render json: @project
    else
      render json: @project.errors, status: :unprocessable_entity
    end
  end

  # DELETE /projects/:id
  def destroy
    @project.destroy
    head :no_content
  end

  # POST /projects/:id/assign_user
  def assign_user
    user = User.find_by(id: params[:user_id])

    if user
      @project.update(user: user)
      render json: @project, status: :ok
    else
      render json: { error: 'User not found' }, status: :not_found
    end
  end

  # PUT /projects/:id/change_status
  def change_status
    if Project::STATUSES.include?(params[:status])
      @project.update(status: params[:status])
      render json: @project, status: :ok
    else
      render json: { error: 'Invalid status' }, status: :unprocessable_entity
    end
  end

  private

  # Set project for actions that need it
  def set_project
    @project = Project.find(params[:id])
  rescue Mongoid::Errors::DocumentNotFound
    render json: { error: 'Project not found' }, status: :not_found
  end

  # Only allow a trusted parameter "white list" through
  def project_params
    params.require(:project).permit(:name, :description, :due_date, :status, :user_id)
  end
end
