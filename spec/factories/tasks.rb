require 'faker'

FactoryGirl.define do
  factory :task do |f|
    f.project
    f.name { Faker::Name.name }
    f.description Faker::Lorem.sentence
    f.done false
    f.priority :medium
  end
end
