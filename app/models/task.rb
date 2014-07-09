class Task < ActiveRecord::Base
  enum priority: [:high, :medium, :low]

  belongs_to :project

  validates :name, presence: true
  validates :project, presence: true

  def self.load_with_project(project_id, user_id, done = nil)
    cond = { project_id: project_id, projects: { user_id: user_id } }
    cond[:done] = done unless done.nil?
    joins(:project)
      .where(cond)
      .order('tasks.done ASC, tasks.priority ASC')
      .eager_load(:project)
  end
end
