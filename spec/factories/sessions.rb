require 'faker'

FactoryGirl.define do
  factory :session do |f|
    f.user 
    f.expires_at 24.hours.from_now

    factory :expired_session do |f|
      after(:create) do |session|
        session.update(expires_at: 24.hours.ago)
      end
    end
  end
end
