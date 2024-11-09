class TasksController < ApplicationController
  before_action :set_task, only: [:show, :update, :destroy]

  def index
    # Use TasksSearcher to handle searching
    tasks_searcher = TasksSearcher.new(params)
    @tasks = tasks_searcher.search

    render 'tasks/index', status: :ok  # Render the `index.json.jbuilder` view
  end

  def show
    render 'tasks/show', status: :ok  # Render the `show.json.jbuilder` view
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Task not found" }, status: :not_found
  end

  def create
    @task = Task.new(task_params)

    if @task.save
      render 'tasks/show', status: :created  # Render `show.json.jbuilder` for the created task
    else
      render json: { errors: @task.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @task.update(task_params)
      render 'tasks/show', status: :ok  # Render `show.json.jbuilder` for the updated task
    else
      render json: { errors: @task.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    if @task.destroy
      render json: { message: "Task successfully deleted" }, status: :no_content
    else
      render json: { error: "Failed to delete task" }, status: :unprocessable_entity
    end
  end

  private

  def set_task
    @task = Task.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Task not found" }, status: :not_found
  end

  def task_params
    params.require(:task).permit(
      :title,
      :description,
      :task_type,
      :due_date,
      :completed_at,
      :note,
      :status,
      :priority,
      :assigned_to_id,
      :project_id
    )
  end
end
