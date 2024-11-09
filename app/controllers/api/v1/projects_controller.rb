class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :update, :destroy, :assign_user, :change_status]

  # GET /projects
  def index
    projects_searcher = ProjectsSearcher.new(params)
    @projects = projects_searcher.call
    # Automatically renders app/views/projects/index.json.jbuilder
  end

  # GET /projects/:id
  def show
    # Automatically renders app/views/projects/show.json.jbuilder
  end

  # POST /projects
  def create
    @project = Project.new(project_params)

    if @project.save
      # Automatically renders app/views/projects/show.json.jbuilder
      render :show, status: :created, location: @project
    else
      render json: { errors: @project.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PUT /projects/:id
  def update
    if @project.update(project_params)
      # Automatically renders app/views/projects/show.json.jbuilder
      render :show, status: :ok
    else
      render json: { errors: @project.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /projects/:id
  def destroy
    @project.destroy
    head :no_content # No content to return, 204 status code
  end

  # POST /projects/:id/assign_user
  def assign_user
    user = User.find_by(id: params[:user_id])

    if user
      @project.update(user: user)
      # Automatically renders app/views/projects/show.json.jbuilder
      render :show, status: :ok
    else
      render json: { error: 'User not found' }, status: :not_found
    end
  end

  # PUT /projects/:id/change_status
  def change_status
    if Project::STATUSES.include?(params[:status])
      @project.update(status: params[:status])
      # Automatically renders app/views/projects/show.json.jbuilder
      render :show, status: :ok
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
