require 'faker'
require 'securerandom'

FactoryBot.define do
  secure_password = SecureRandom.hex(16)

  factory :user do
    email { Faker::Internet.unique.email }
    password { secure_password }
    password_confirmation { secure_password }
  end
end
