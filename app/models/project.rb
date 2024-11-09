class Project
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :description, type: String
  field :due_date, type: DateTime
  field :completed_at, type: DateTime

  enum :status, STATUSES
  enum :project_type, PROJECT_TYPES

  has_many :tasks
  belongs_to :creator, class_name: "User"
  belongs_to :assigned_to, class_name: "User"

  index({ name: 1 })
  index({ due_date: 1 })
  index({ project_type: 1 })

  PROJECT_TYPES = {
    internal: "internal",
    client: "client",
    research: "research",
    marketing: "marketing",
    development: "development"
  }

  STATUSES = {
    todo: "todo",
    pending: "pending",
    completed: "completed",
    archived: "archived"
  }
end
