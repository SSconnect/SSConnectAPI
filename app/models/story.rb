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

  def regist_tag(tags, without_save=false)
    return if tags.empty?
    unless tags.kind_of?(Array)
      tags = [tags]
    end
    tag_list = self.tag_list.concat(tags.map { |tag| Swing.trans(tag.tr('SS', '')) })
    save unless without_save
  end

  # 新しい title の Story の作成または既存の Story へ Merge する
  def rename_title(title)
    return if title == self.title
    story = Story.find_or_create_by(title: title)
    story.articles += articles
    story.regist_tag(tag_list)
    destroy
  end

  after_save do
    bracket_check
  end

  # 【このすば】のようなキーワードを取り除く
  def bracket_check
    # Swing check
    swing_words = bracket_words.select { |word| Swing.include? word }
    tags = swing_words.map { |word| Swing.trans(word) }
    # Tag check
    tag_words = bracket_words.select { |word| !ActsAsTaggableOn::Tag.find_by_name(word).nil? }
    tags += tag_words

    return if tags.empty?
    regist_tag(tags, true)
    pattern = (swing_words + tag_words).map { |word| "【#{word}】" }.join('|')
    rename_title title.gsub(/#{pattern}/, '')
  end

  def bracket_words
    (title.scan /【(.*?)】/).flatten
  end

  def self.remove_bracket_all(tag)
    word_bra = "【#{tag}】"
    Story.where("title like '%#{word_bra}%'").each do |story|
      title = story.title.gsub word_bra, ''
      story.regist_tag(tag)
      story.rename_title(title)
    end
  end

end
