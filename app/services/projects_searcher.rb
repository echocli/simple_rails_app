class ProjectsSearcher
  def initialize(params)
    @params = params
    @criteria = Project
  end

  def search
    # Apply filters
    @criteria = filter_by_name(@criteria)
    @criteria = filter_by_description(@criteria)
    @criteria = filter_by_status(@criteria)

    # Apply sorting if specified
    @criteria = apply_sorting(@criteria)

    @criteria
  end

  private

  # Method to handle sorting logic
  def apply_sorting(projects)
    if @params[:sort_by].present?
      sort_field = @params[:sort_by].to_sym # Convert to symbol for Mongoid compatibility
      sort_order = @params[:sort_order] == 'asc' ? :asc : :desc  # Default to descending if not 'asc'
      projects = projects.order_by(sort_field => sort_order)
    end
    projects
  end

  # Filter by name using case-insensitive regex match
  def filter_by_name(projects)
    if @params[:query].present?
      projects.where(name: /#{Regexp.escape(@params[:query])}/i)
    else
      projects
    end
  end

  # Filter by description using case-insensitive regex match
  def filter_by_description(projects)
    if @params[:query].present?
      projects.where(description: /#{Regexp.escape(@params[:query])}/i)
    else
      projects
    end
  end

  # Filter by status
  def filter_by_status(projects)
    if @params[:status].present?
      projects.where(status: @params[:status])
    else
      projects
    end
  end
end
