class TaskSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :done, :priority, :created_at, :project
end
