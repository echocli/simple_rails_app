# app/views/users/index.json.jbuilder
json.array! @users do |user|
  json.extract! user, :id, :name, :email, :age, :created_at, :updated_at
end
