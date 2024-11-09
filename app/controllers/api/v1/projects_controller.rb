class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :update, :destroy, :assign_user, :change_status]

  def index
    projects_searcher = ProjectsSearcher.new(params)
    @projects = projects_searcher.search
  end

  def create
    @project = Project.new(project_params)

    if @project.save
      @project.reload
    else
      render json: { errors: @project.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @project.update(project_params)
      @project.reload
    else
      render json: { errors: @project.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    if @project.destroy
      @project.reload
    else
      render json: { error: "Failed to delete project" }, status: :unprocessable_entity
    end
  end

  private

  def set_project
    @project = Project.find(params[:id])
  rescue Mongoid::Errors::DocumentNotFound
    render json: { error: 'Project not found' }, status: :not_found
  end

  def project_params
    params.require(:project).permit(:name, :description, :due_date, :status, :user_id, :project_type)
  end
end
