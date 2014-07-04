class Project < ActiveRecord::Base
  include FriendlyId
  friendly_id :name, use: :scoped, scope: :author

  belongs_to :author, class_name: 'User', foreign_key: 'user_id'

  has_many :tasks

  validates :author, presence: true
  validates :name, presence: true
  validates :slug, presence: true, uniqueness: { scope: :author }
end
