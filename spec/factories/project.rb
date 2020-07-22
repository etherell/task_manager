require 'faker'

FactoryBot.define do
  factory :project do
    title { Faker::Lorem.sentence(word_count: 3, supplemental: true) }
    user

    factory :project_with_tasks do
      transient do
        tasks_count { 10 }
      end

      after(:create) do |project, evaluator|
        create_list(:task, evaluator.tasks_count, project: project)
      end
    end
  end
end
