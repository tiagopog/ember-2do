require 'faker'

FactoryGirl.define do
  factory :user do |f|
    f.name { Faker::Name.name }
    f.email { Faker::Internet.free_email }
    f.password Faker::Internet.password(8)
    f.avatar_url "http://pbs.twimg.com/profile_images/\
                378800000331404298/\
                632e1ce57cc737933c4d9ee3b5a766a9_normal.jpeg"

    factory :user_with_projects do
      ignore { projects_count 3 }

      after(:create) do |user, eval|
        create_list(:project_with_tasks, eval.projects_count, author: user)
      end
    end

    factory :user_to_serialize do |f|
      f.id 999
      f.name 'Tiago Guedes'
      f.email 'foobar@gmail.com'
      f.avatar_url 'http://gravatar.com/foobar.jpg'
      f.created_at '2014-07-23T14:04:00.255Z'
    end
  end
end
