class TasksController < ApplicationController
  before_action :set_task, only: [:show, :update, :destroy]

  def index
    tasks_searcher = TasksSearcher.new(task_params)
    @tasks = tasks_searcher.search
  end

  def create
    @task = Task.new(params)

    if @task.save
      @task.reload
    else
      render json: { errors: @task.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @task.update(task_params)
      @task.reload
    else
      render json: { errors: @task.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    if @task.destroy
      @task.reload
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
    params.permit(
      :title,
      :description,
      :task_type,
      :due_date,
      :completed_at,
      :note,
      :status,
      :priority,
      :assigned_to_id,
      :project_id,
    )
  end
end
