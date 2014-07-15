class TaskSerializer < ActiveModel::Serializer
  attributes :id, :project_id, :name, :description, :done, :priority, :created_at
end
