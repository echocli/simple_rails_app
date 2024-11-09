class UsersSearcher
  attr_reader :params

  def initialize(params)
    @params = params
    @criteria = User
  end

  def search
    # Apply filters dynamically based on params
    @criteria = apply_filters(@criteria)

    # Apply sorting if specified (optional, can be added later)
    @criteria = apply_sorting(@criteria)

    @criteria.to_a
  end

  private

  # Apply filters based on search parameters
  def apply_filters(users)
    users = users.where(name: /#{Regexp.escape(@params[:name])}/i) if @params[:name].present?
    users = users.where(email: /#{Regexp.escape(@params[:email])}/i) if @params[:email].present?

    users
  end

  # Optional: Apply sorting based on sort_by_field and sort_asc params
  def apply_sorting(users)
    if @params[:sort_by_field].present? && @params[:sort_asc].present?
      sort_direction = @params[:sort_asc] == 'true' ? :asc : :desc
      users = users.order_by(@params[:sort_by_field].to_sym => sort_direction)
    end
    users
  end
end
