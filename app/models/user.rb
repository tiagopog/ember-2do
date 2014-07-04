class User < ActiveRecord::Base
  has_many :projects, dependent: :destroy
  has_many :tasks, through: :projects

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, email: true

  def avatar; self[:avatar_url] || gravatar end
  def gravatar; Gravatar.new(self[:email]).image_url end
end
