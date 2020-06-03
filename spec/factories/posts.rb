FactoryBot.define do
  factory :post do
    caption { Faker::Lorem.sentence(word_count: 5) }
  end
end
