FactoryBot.define do
  factory :post do
    caption { Faker::Lorem.sentence(word_count: 5) }
    trait :with_image do
      image { FilesTestHelper.png }
    end
  end
end
