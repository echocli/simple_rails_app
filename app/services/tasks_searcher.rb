class TasksSearcher
  def initialize(params)
    @params = params
    @criteria = Task
  end

  def search
    @criteria = apply_filters(@criteria)
    @criteria = apply_sorting(@criteria)
    @criteria.to_a
  end

  private

  def apply_filters(tasks)
    tasks = tasks.where(:task_type.in => @params[:task_types]) if @params[:task_types].present?
    tasks = tasks.where(:assigned_to_id.in => @params[:assigned_to_ids]) if @params[:assigned_to_ids].present?
    tasks = tasks.where(due_date: { "$gte" => DateTime.parse(@params[:due_date]) }) if @params[:due_date].present?
    tasks = tasks.where(created_at: { "$gte" => DateTime.parse(@params[:created_at]) }) if @params[:created_at].present?
    tasks = tasks.where(completed_at: { "$gte" => DateTime.parse(@params[:completed_at]) }) if @params[:completed_at].present?

    tasks
  end

  def apply_sorting(tasks)
    if @params[:sort_by_field].present? && @params[:sort_asc].present?
      tasks = tasks.order_by(@params[:sort_by_field].to_sym => @params[:sort_asc] == "true" ? :asc : :desc)
    end
    tasks
  end
end
