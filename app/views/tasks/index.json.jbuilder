json.array! @tasks do |task|
  json.id task.id.to_s
  json.title task.title
  json.description task.description
  json.task_type task.task_type
  json.due_date task.due_date
  json.completed_at task.completed_at
  json.note task.note
  json.status task.status
  json.priority task.priority
  json.creator_id task.creator_id.to_s
  json.assigned_to_id task.assigned_to_id.to_s
  json.project_id task.project_id.to_s
end

