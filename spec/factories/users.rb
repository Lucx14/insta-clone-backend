FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    username { Faker::Internet.username(specifier: 4..20, separators: %w[- _]) }
    email { Faker::Internet.email }
    password { 'password' }
    trait :with_avatar do
      avatar { FilesTestHelper.avatar_png }
    end
  end
end
