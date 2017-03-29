class Swing < ApplicationRecord
  validates :wrong, presence: true, uniqueness: true
  validates :correct, presence: true

  def self.lib
    @@lib ||= Swing.all.map { |x| [x.wrong, x.correct] }.to_h
  end

  def self.lib_drop
    @@lib = nil
  end

  def self.trans(tag)
    lib[tag] || tag
  end

  after_create do
    stories = Story.tagged_with(self.wrong)
    stories.all.each do |story|
      story.tag_list.remove(self.wrong)
      story.tag_list.add(self.correct)
      story.save
    end

  end

  after_save do
    Swing.lib_drop
  end
end
