# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :task do
    project nil
    name "MyString"
    description "MyText"
    done false
    priority 1
  end
end
