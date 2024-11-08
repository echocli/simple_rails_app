# app/services/users_searcher.rb
class UsersSearcher
  attr_reader :params

  def initialize(params)
    @params = params
  end

  def call
    search_query = build_query
    User.where(search_query)
  end

  private

  def build_query
    query = {}

    # Filter by name (case-insensitive regex match)
    query[:name] = /#{Regexp.escape(params[:name])}/i if params[:name].present?

    # Filter by email (case-insensitive regex match)
    query[:email] = /#{Regexp.escape(params[:email])}/i if params[:email].present?

    # Filter by age range (if provided)
    if params[:age_min].present? || params[:age_max].present?
      age_query = {}
      age_query['$gte'] = params[:age_min].to_i if params[:age_min].present?
      age_query['$lte'] = params[:age_max].to_i if params[:age_max].present?
      query[:age] = age_query unless age_query.empty?
    end

    query
  end
end
