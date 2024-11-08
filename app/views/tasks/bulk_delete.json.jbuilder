
json.array!(@tasks) do |task|
  json.message "Task #{task.id} has been deleted successfully."
  json.id task.id
end
