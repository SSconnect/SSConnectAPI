# == Schema Information
#
# Table name: stories
#
#  id         :integer          not null, primary key
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Story < ApplicationRecord
  validates :title, presence: true
  has_many :articles
  acts_as_taggable

  def regist_tag(tags)
    unless tags.kind_of?(Array)
      tags = [tags]
    end
    tag_list = self.tag_list.concat(tags.map { |tag| Swing.trans(tag.tr('SS', '')) })
    save
  end

  def rename_title(title)
    story = Story.find_or_create_by(title: title)
    story.articles += articles
    story.regist_tag(tag_list)
    destroy
  end
end
