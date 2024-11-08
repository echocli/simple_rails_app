# app/views/users/create.json.jbuilder
json.extract! @user, :id, :name, :email, :age, :created_at, :updated_at
json.message "User created successfully"
