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

    factory :project_to_serialize do |f|
      f.id 9999
      f.name 'Awesome project!'
      f.created_at '2014-07-23T00:13:58.718Z'
      
      after(:create) do |project|
        create_list(:task, 1, 
          id: 9999,
          project: project,
          name: 'Do it now',
          created_at: '2014-07-23T00:13:58.749Z',
          description: 'Lorem ipsum dolor sit amet.')
      end
    end
  end
end
  