require 'faker'

FactoryGirl.define do
  factory :project do |f|
    f.name { Faker::Name.name }
    f.slug { Faker::Internet.slug }
    f.association :author, factory: :user 

    factory :project_with_tasks do
      ignore { tasks_count 3 }

      after(:create) do |project, eval|
        create_list(:task, eval.tasks_count, project: project)
      end
    end
  end
end
  