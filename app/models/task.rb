class Task
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title, type: String
  field :description, type: String
  field :due_date, type: DateTime
  field :completed_at, type: DateTime
  field :note, type: String

  enum :task_type, TASK_TYPES
  enum :status, STATUSES
  enum :priority, PRIORITIES

  belongs_to :creator, class_name: "User"
  belongs_to :assigned_to, class_name: "User"
  belongs_to :project

  index({ status: 1 })
  index({ due_date: 1 })
  index({ project_id: 1 })
  index({ assigned_to: 1 })

  TASK_TYPES = {
    bug: "bug",
    feature: "feature",
    improvement: "improvement",
    research: "research"
  }

  STATUSES = {
    todo: "todo",
    pending: "pending",
    completed: "completed",
    archived: "archived"
  }

  PRIORITIES = {
    0 => "high",
    1 => "medium",
    2 => "low",
  }
end
