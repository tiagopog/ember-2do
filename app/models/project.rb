class Project < ActiveRecord::Base
  include FriendlyId
  friendly_id :name, use: :scoped, scope: :author

  belongs_to :author, class_name: 'User', foreign_key: 'user_id'

  has_many :tasks, dependent: :destroy

  validates :author, presence: true
  validates :name, presence: true
  validates :slug, presence: true, uniqueness: { scope: :author }

  def self.load_with_tasks(user_id, slug)
    where(user_id: user_id, slug: slug)
      .eager_load(:tasks)
      .order('tasks.done ASC, tasks.priority ASC')
      .first
  end

  def should_generate_new_friendly_id?; name_changed? end
end
