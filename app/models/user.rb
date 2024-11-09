# app/models/user.rb
class User
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :email, type: String

  # Ensuring email is unique
  index({ email: 1 }, { unique: true, name: "email_index" })

  # Validations
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
end
