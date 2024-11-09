json.tasks @projects do |task|
  json.partial! 'api/v1/projects/project', project: project
end