json.(project,
  :id,
  :name,
  :description,
  :due_date,
  :completed_at,
  :status_cd,
  :project_type_cdv,
  :creator_id,
  :assigned_to_id,
  :created_at,
  :updated_at
)

json.tasks @project.tasks do |task|
  json.partial! 'api/v1/tasks/task', task: task
end