class Task < ActiveRecord::Base
  enum priority: [:high, :medium, :low]

  belongs_to :project

  validates :name, presence: true
  validates :project, presence: true

  def self.filter(tasks, done = nil)
    done.nil? ? tasks : tasks.select { |e| e.done == done }
  end
end
