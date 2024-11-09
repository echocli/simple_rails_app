class Project
  include Mongoid::Document
  include Mongoid::Timestamps

  # Fields for the project model
  field :name, type: String
  field :description, type: String
  field :due_date, type: DateTime
  field :status, type: String, default: "active" # active, completed, etc.
  field :project_type, type: String # new field for project type

  # Associations
  has_many :tasks
  belongs_to :user, optional: true # Optional, assuming a project could be assigned to a user

  # Validations
  validates :name, presence: true
  validates :due_date, presence: true
  validates :project_type, presence: true, inclusion: { in: ["internal", "client", "research", "marketing", "development"] }

  # Indexing for performance
  index({ name: 1 })
  index({ due_date: 1 })
  index({ project_type: 1 }) # Indexing the project_type for better search performance

  # Enum for project status
  STATUSES = ["active", "completed", "archived"]

  # Enum for project types (optional if you want predefined project types)
  PROJECT_TYPES = ["internal", "client", "research", "marketing", "development"]
end
