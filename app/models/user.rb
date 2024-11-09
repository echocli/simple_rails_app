# app/models/user.rb
class User
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :email, type: String

  index({ email: 1 }, { unique: true, name: "email_index" })
end
