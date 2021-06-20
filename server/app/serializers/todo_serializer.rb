class TodoSerializer < ActiveModel::Serializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :title, :short_description, :is_public, :created_at, :updated_at
  belongs_to :user
  has_many :tasks
end
