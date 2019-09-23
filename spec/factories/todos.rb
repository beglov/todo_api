FactoryBot.define do
  factory :todo do
    user
    title { Faker::Lorem.word }
    body { Faker::Lorem.word }
  end
end