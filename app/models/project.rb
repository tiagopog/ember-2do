class Project < ActiveRecord::Base
  include FriendlyId
  friendly_id :name, use: :slugged

  belongs_to :user
end
