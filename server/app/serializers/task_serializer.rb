class TaskSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :content, :expired_at, :is_public, :status, :created_at, :updated_at
  belongs_to :user
  belongs_to :todo
end
