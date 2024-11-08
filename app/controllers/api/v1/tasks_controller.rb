class TasksController < ApplicationController
  before_action :set_task, only: [:show, :update, :destroy]

  def index
    # Use TasksSearcher to handle searching
    tasks_searcher = TasksSearcher.new(params)
    tasks = tasks_searcher.search

    render json: tasks
  end

  def show
    render json: @task
  end

  def create
    task = Task.new(task_params)

    if task.save
      render json: task, status: :created
    else
      render json: { errors: task.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @task.update(task_params)
      render json: @task
    else
      render json: { errors: @task.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    @task.destroy
    head :no_content
  end

  def bulk_create
    tasks = Task.insert_many(task_params[:tasks])

    if tasks.present?
      render json: tasks, status: :created
    else
      render json: { errors: "Failed to create tasks" }, status: :unprocessable_entity
    end
  end

  def bulk_update
    tasks = Task.where(id: task_params[:task_ids]).update_all(task_params[:task_updates])

    if tasks > 0
      render json: { message: "#{tasks} tasks updated successfully" }
    else
      render json: { errors: "Failed to update tasks" }, status: :unprocessable_entity
    end
  end

  def bulk_assign
    tasks = Task.where(id: task_params[:task_ids])
                .update_all(assigned_to_id: task_params[:assigned_to_id])

    if tasks > 0
      render json: { message: "#{tasks} tasks assigned successfully" }
    else
      render json: { errors: "Failed to assign tasks" }, status: :unprocessable_entity
    end
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(
      :task_type,
      :assigned_to_id,
      :due_date,
      :note,
      :created_at,
      :updated_at,
      :completed_at,
      tasks: [:task_type, :assigned_to_id, :due_date, :note, :created_at, :updated_at],
      task_ids: [],
      task_updates: {},
      sort_by_field: :task_due_at,
      sort_asc: :true,
      sort_desc: :false
    )
  end
end
