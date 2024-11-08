
json.array!(@tasks) do |task|
  json.id task.id
  json.assigned_to_id task.assigned_to_id
  json.assigned_to_user task.assigned_to.user.name
  json.task_type task.task_type
  json.due_date task.due_date
  json.created_at task.created_at
  json.updated_at task.updated_at
  json.completed_at task.completed_at
  json.note task.note
end
