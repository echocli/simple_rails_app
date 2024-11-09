class UsersSearcher
  def initialize(params)
    @params = params
    @criteria = User
    apply_filters
    apply_sorting
  end

  def search
    @criteria.to_a
  end

  private

  def apply_filters
    # Apply general filters based on parameters
    @criteria = filter_by_param(:user_ids, :id)
    @criteria = filter_by_param(:emails, :email)
  end

  def filter_by_param(param_key, field)
    if @params[param_key].present?
      @criteria = @criteria.where(field.in => @params[param_key])
    end
  end

  def apply_sorting
    if @params[:sort_by_field].present?
      direction = @params[:sort_asc] == "true" ? :asc : :desc
      @criteria = @criteria.order_by(@params[:sort_by_field].to_sym => direction)
    end
  end
end
