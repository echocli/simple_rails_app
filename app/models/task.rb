class Task
  include Mongoid::Document
  include Mongoid::Timestamps

  # Fields for the task model
  field :title, type: String
  field :description, type: String
  field :task_type, type: String
  field :due_date, type: DateTime
  field :completed_at, type: DateTime
  field :note, type: String
  field :status, type: String
  field :priority, type: Integer

  # Associations
  belongs_to :creator, class_name: "User", inverse_of: :created_tasks
  belongs_to :assigned_to, class_name: "User", inverse_of: :assigned_tasks, optional: true
  belongs_to :project, optional: true # A task can belong to a project

  # Validations
  validates :title, presence: true
  validates :due_date, presence: true

  # Indexes for optimization
  index({ status: 1 })
  index({ due_date: 1 })
  index({ project_id: 1 })

  # Enum for task types
  TASK_TYPES = ["bug", "feature", "improvement", "research"]

  # Enum for task status
  STATUSES = ["todo", "in-progress", "completed"]
end
