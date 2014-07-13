class ProjectSerializer < ActiveModel::Serializer
  attributes :id, :name, :slug, :user_id, :created_at, :tasks
end
