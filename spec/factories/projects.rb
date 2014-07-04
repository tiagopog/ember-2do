require 'faker'

FactoryGirl.define do
  factory :project do |f|
    f.name { Faker::Name.name }
    f.slug { Faker::Internet.slug }
    f.user nil
  end
end
