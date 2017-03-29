# == Schema Information
#
# Table name: stories
#
#  id              :integer          not null, primary key
#  title           :string
#  first_posted_at :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Story < ApplicationRecord
  validates :title, presence: true
  has_many :articles, :dependent => :delete_all
  acts_as_taggable

  def regist_tag(tags)
    unless tags.kind_of?(Array)
      tags = [tags]
    end
    tag_list = self.tag_list.concat(tags.map { |tag| Swing.trans(tag.tr('SS', '')) })
    save
  end

  # 新しい title の Story の作成または既存の Story へ Merge する
  def rename_title(title)
    story = Story.find_or_create_by(title: title)
    story.articles += articles
    story.regist_tag(tag_list)
    destroy
  end

  # 【このすば】のようなキーワードを取り除く
  def bracket_check
    tag_words = bracket_words.filter { |word| Swing.lib.includes word }
    tags = tag_words.map { |word| Swing.trans(word) }
    regist_tag(tags)
    pattern = tag_words.map { |word| "【#{word}】" }.join('|')
    rename_title title.gsub(pattern, '')
  end

  def bracket_words
    (title.scan /【(.*?)】/).flatten
  end
end
