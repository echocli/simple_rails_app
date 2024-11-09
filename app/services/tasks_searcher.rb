class TasksSearcher
  def initialize(params)
    @params = params
    @criteria = Task
    apply_filters
    apply_sorting
  end

  def search
    @criteria.to_a
  end

  private

  def apply_filters
    # Apply general filters based on parameters
    @criteria = filter_by_param(:task_ids, :id)
    @criteria = filter_by_param(:task_types, :task_type_cd)
    @criteria = filter_by_param(:statuses, :status_cd)
    @criteria = filter_by_param(:project_ids, :project_id)
    @criteria = filter_by_param(:creator_ids, :creator_id)
    @criteria = filter_by_param(:assigned_to_ids, :assigned_to_id)
    @criteria = filter_by_param(:priorities, :priority_cd)

    # Apply date range filters
    @criteria = apply_date_range_filters
  end

  def filter_by_param(param_key, field)
    if @params[param_key].present?
      @criteria = @criteria.where(field.in => @params[param_key])
    end
  end

  def apply_date_range_filters
    @criteria = apply_date_filter(:due_date)
    @criteria = apply_date_filter(:created_at)
    @criteria = apply_date_filter(:completed_at)
    @criteria = apply_date_filter(:updated_at)
  end

  def apply_date_filter(field)
    min_param = "#{field}_min".to_sym
    max_param = "#{field}_max".to_sym

    if @params[min_param].present? && @params[max_param].present?
      @criteria = @criteria.where(field => { "$gte" => DateTime.parse(@params[min_param]), "$lte" => DateTime.parse(@params[max_param]) })
    elsif @params[min_param].present?
      @criteria = @criteria.where(field => { "$gte" => DateTime.parse(@params[min_param]) })
    elsif @params[max_param].present?
      @criteria = @criteria.where(field => { "$lte" => DateTime.parse(@params[max_param]) })
    end

  end

  def apply_sorting
    if @params[:sort_by_field].present?
      direction = @params[:sort_asc] == "true" ? :asc : :desc
      @criteria = @criteria.order_by(@params[:sort_by_field].to_sym => direction)
    end
  end
end
