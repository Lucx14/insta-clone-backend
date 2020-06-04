FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    username { Faker::Internet.username(specifier: 4..20) }
    email { Faker::Internet.email }
    password { 'password' }
  end
end
