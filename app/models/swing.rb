class Swing < ApplicationRecord
  validates :wrong, presence: true, uniqueness: true
  validates :correct, presence: true
  after_create do
    stories = Story.tagged_with(self.wrong)
    stories.all.each do |story|
      story.tag_list.remove(self.wrong)
      story.tag_list.add(self.correct)
      story.save
  end
  end
end
