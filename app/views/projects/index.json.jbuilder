json.array!(@projects) do |project|
  json.id project.id
  json.name project.name
  json.description project.description
  json.status project.status
  json.due_date project.due_date
  json.user_id project.user_id
end
