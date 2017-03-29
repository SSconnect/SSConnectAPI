# == Schema Information
#
# Table name: stories
#
#  id         :integer          not null, primary key
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

def rand_brancket
  (rand(2) == 0) ? "【#{FFaker::Food.meat}】" : ''
end

FactoryGirl.define do
  factory :story do
    title { "#{FFaker::NameJA.name}「あいうえお」#{FFaker::NameJA.name}「かきくけこ」" }
    factory :story_bracket do
      title {
        say1 = %w(AAA BBB CCC).sample + '「あいうえお」'
        say2 = %w(AAA BBB CCC).sample + '「かきくけこ」'
        rand_brancket + say1 + rand_brancket + say2 + rand_brancket
      }
    end
  end
end
