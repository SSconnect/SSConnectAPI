class Bracket < ApplicationRecord
  validates :title, presence: true, uniqueness: true

  def bra
    '【' + self.title + '】'
  end

  def self.bra_list
    pluck(:title)
  end

  after_create do
    stories = Story.where('title LIKE ?', "%#{bra}%")
    stories.each do |story|
      title = story.title
      tags = story.tag_list
      new_title = Story.space_delete(Story.fix_title(title,tags))
      story.rename_title(new_title)
    end
  end

end
