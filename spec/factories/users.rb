require 'faker'

FactoryGirl.define do
  factory :user do |f|
    f.name { Faker::Name.name }
    f.email { Faker::Internet.free_email }
    f.token 'ZzqHMwweixo1BQHf-Tj3Jg'
    f.avatar_url "http://pbs.twimg.com/profile_images/\
                378800000331404298/\
                632e1ce57cc737933c4d9ee3b5a766a9_normal.jpeg"
  end
end
