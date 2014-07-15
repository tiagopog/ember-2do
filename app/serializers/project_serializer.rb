class ProjectSerializer < ActiveModel::Serializer
  attributes :id, :name, :slug, :created_at
  has_many :tasks
end
