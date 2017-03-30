# == Schema Information
#
# Table name: swings
#
#  id         :integer          not null, primary key
#  wrong      :string
#  correct    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Swing < ApplicationRecord
  validates :wrong, presence: true, uniqueness: true
  validates :correct, presence: true

  def self.lib
    @@lib ||= Swing.all.map { |x| [x.wrong, x.correct] }.to_h
  end

  def self.lib_drop
    @@lib = nil
  end

  def self.libTrans(tag)
    lib[tag] || tag
  end

  def self.trans(tag)
    swing = Swing.find_by_wrong(tag)
    return tag if swing.nil?
    swing.correct
  end

  def self.include? tag
    trans(tag) != tag
  end

  after_create do
    stories = Story.tagged_with(self.wrong)
    stories.all.each do |story|
      story.tag_list.remove(self.wrong)
      story.tag_list.add(self.correct)
      story.save
    end
    Story.remove_bracket_all(self.wrong)
    Story.remove_bracket_all(self.correct)
  end
end
