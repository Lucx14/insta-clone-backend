# Seed 50 records
10.times do
  Post.create(caption: Faker::Lorem.sentence(word_count: 5))
end
