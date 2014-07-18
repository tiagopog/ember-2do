class TaskSerializer < ActiveModel::Serializer
  embed :ids

  attributes :id, :name, :description, :done, :priority, :created_at
  
  has_one :project
end
