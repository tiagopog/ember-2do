# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :session do
    user nil
    token "MyString"
    expires_at "2014-07-05 02:49:06"
  end
end
