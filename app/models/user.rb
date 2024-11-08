# app/models/user.rb
class User
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :email, type: String
  field :age, type: Integer

  # Ensuring email is unique
  index({ email: 1 }, { unique: true, name: "email_index" })

  # Validations
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :age, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true
end
