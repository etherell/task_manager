require 'faker'

FactoryBot.define do
  factory :project do
    title { Faker::Lorem.sentence(word_count: 3, supplemental: true) }
    user
  end
end
