# Seed 50 records
user = User.create(name: 'seedUser', username: 'seedUser', email: 'seedUser@email.com', password: 'password')
10.times do
  Post.create(caption: Faker::Lorem.sentence(word_count: 5), user: user)
end
