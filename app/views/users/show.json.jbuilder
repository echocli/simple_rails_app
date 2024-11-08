# app/views/users/show.json.jbuilder
json.extract! @user, :id, :name, :email, :age, :created_at, :updated_at
