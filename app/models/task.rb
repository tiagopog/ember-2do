class Task < ActiveRecord::Base
  enum priority: [:high, :medium, :low]

  belongs_to :project

  validates :name, presence: true
  validates :project, presence: true
end
