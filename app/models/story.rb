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
    return self if tags.empty?
    self.tag_list = self.tag_list.concat(tags.map { |tag| Swing.trans(tag.tr('SS', '')) })
    save unless without_save
    self
  end

  # 新しい title の Story の作成または既存の Story へ Merge する
  def rename_title(title)
    return if title == self.title
    story = Story.find_or_create_by(title: title)
    story.articles += articles
    story.regist_tag(tag_list)
    destroy
    return story
  end

  def bracket_words
    (title.scan /【(.*?)】/).flatten
  end

  def self.remove_bracket_all(tag)
    word_bra = "【#{tag}】"
    Story.where("title like '%#{word_bra}%'").each do |story|
      title = story.title.gsub word_bra, ''
      story.regist_tag([tag])
      story.rename_title(title)
    end
  end


  #
  # title: タイトル
  # tags:  新規タグ
  #
  def self.regist_story(title,tags)
    title = fix_title(title,tags)
    find_or_create_by(title: title).regist_tag(tags)
  end

  def self.fix_title(title, tags)
    title = remove_bracket_filter(title, tags)
    title
  end

  def self.remove_bracket_filter(title, tags)
    wrong_words = bracket_words_2(title).select { |word| Swing.include? word }
    # Tag check
    tag_words = bracket_words_2(title).select { |word| !ActsAsTaggableOn::Tag.find_by_name(word).nil? }
    pattern = (wrong_words + tag_words + tags).map { |word| "【#{word}】" }.join('|')
    title.gsub(/#{pattern}/, '')
  end

  def self.bracket_words_2(title)
    (title.scan /【(.*?)】/).flatten
  end

end
