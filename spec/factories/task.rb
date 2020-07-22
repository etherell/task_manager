require 'faker'

FactoryBot.define do
  factory :task do
    description { Faker::Lorem.sentence(word_count: 3, supplemental: true) }
    sequence(:position)
    deadline { Time.zone.now.tomorrow }
    is_done { false }
    user
    project
  end
end
