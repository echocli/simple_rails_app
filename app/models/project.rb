class Project
  include Mongoid::Document
  include Mongoid::Timestamps

  # Fields for the project model
  field :name, type: String
  field :description, type: String
  field :due_date, type: DateTime
  field :status, type: String, default: "active" # active, completed, etc.

  # Associations
  has_many :tasks
  belongs_to :user, optional: true # Optional, assuming a project could be assigned to a user

  # Validations
  validates :name, presence: true
  validates :due_date, presence: true

  # Indexing for performance
  index({ name: 1 })
  index({ due_date: 1 })

  # Enum for project status
  STATUSES = ["active", "completed", "archived"]
end
