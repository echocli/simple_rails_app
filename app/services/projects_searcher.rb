class ProjectsSearcher
  def initialize(params)
    @params = params
  end

  def call
    search_projects
  end

  private

  def search_projects
    projects = Project.all

    projects = filter_by_name(projects)
    projects = filter_by_description(projects)
    projects = filter_by_status(projects)

    projects
  end

  def filter_by_name(projects)
    if @params[:query].present?
      projects.where(name: /#{@params[:query]}/i)
    else
      projects
    end
  end

  def filter_by_description(projects)
    if @params[:query].present?
      projects.or(description: /#{@params[:query]}/i)
    else
      projects
    end
  end

  def filter_by_status(projects)
    if @params[:status].present?
      projects.where(status: @params[:status])
    else
      projects
    end
  end
end
