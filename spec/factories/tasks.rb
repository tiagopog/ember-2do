require 'faker'

FactoryGirl.define do
  factory :task do |f|
    f.project
    f.name { Faker::Name.name }
    f.description Faker::Lorem.sentence
    f.done false
    f.priority :medium

    factory :task_to_serialize do |f|
      f.id 999
      f.project Project.new(id: 999)
      f.name 'Do it now'
      f.created_at '2014-07-23T00:13:58.749Z'
      f.description 'Lorem ipsum dolor sit amet.'
    end
  end
end
