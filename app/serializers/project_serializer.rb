class ProjectSerializer < ActiveModel::Serializer
  embed :ids, include: true
  
  attributes :id, :name, :slug, :created_at

  has_many :tasks
end
