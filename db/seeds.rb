# Seed 50 records
user = User.create(name: 'seedUser', username: 'seedUser', email: 'seedUser@email.com', password: 'password')
User.create(name: 'odo', username: 'odo', email: 'odo@email.com', password: 'password')
User.create(name: 'kira', username: 'kira', email: 'kira@email.com', password: 'password')
User.create(name: 'dax', username: 'dax', email: 'dax@email.com', password: 'password')
User.create(name: 'sisko', username: 'sisko', email: 'sisko@email.com', password: 'password')

10.times do
  Post.create(caption: Faker::Lorem.sentence(word_count: 5), user: user)
end
