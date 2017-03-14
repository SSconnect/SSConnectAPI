# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
AdminUser.create!(email: 'sample@cps.im.dendai.ac.jp', password: 'rubirubiSS', password_confirmation: 'rubirubiSS')

stories = []
100.times do |j|
  story = FactoryGirl.create(:story)
  (1..5).to_a.sample.times do
    story.tag_list << FFaker::Food.fruit
  end
  story.save
  stories << story
end

10.times do |i|
  blog = FactoryGirl.create(:blog)

  100.times do |j|
    FactoryGirl.create(:article, blog: blog, story: stories[j])
  end
  puts i
end
