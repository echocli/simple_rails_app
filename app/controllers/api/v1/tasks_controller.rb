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

  def bulk_create
    tasks = task_params[:tasks].map { |task_data| Task.new(task_data) }
    tasks_saved = tasks.select(&:save)

    if tasks_saved.any?
      render 'tasks/bulk_create', status: :created  # Render `bulk_create.json.jbuilder` for created tasks
    else
      render json: { errors: tasks.reject(&:persisted?).map(&:errors) }, status: :unprocessable_entity
    end
  end

  def bulk_update
    updated_tasks = Task.where(id: task_params[:task_ids]).update_all(task_params[:task_updates])

    if updated_tasks > 0
      render json: { message: "#{updated_tasks} tasks successfully updated" }, status: :ok
    else
      render json: { error: "No tasks updated" }, status: :unprocessable_entity
    end
  end

  def bulk_assign
    updated_tasks = Task.where(id: task_params[:task_ids]).update_all(assigned_to_id: task_params[:assigned_to_id])

    if updated_tasks > 0
      render json: { message: "#{updated_tasks} tasks successfully assigned" }, status: :ok
    else
      render json: { error: "No tasks assigned" }, status: :unprocessable_entity
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
