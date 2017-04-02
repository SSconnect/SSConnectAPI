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
    self.tag_list = self.tag_list.concat(tags.map { |tag| Swing.trans(tag.tr('SS', '')) })
    save unless without_save
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

  after_save do
    that = bracket_check
    that.end_tag_check
  end

  # 【このすば】のようなキーワードを取り除く
  def bracket_check
    # Swing check
    swing_words = bracket_words.select { |word| Swing.include? word }
    tags = swing_words.map { |word| Swing.trans(word) }
    # Tag check
    tag_words = bracket_words.select { |word| !ActsAsTaggableOn::Tag.find_by_name(word).nil? }
    tags += tag_words

    return self if tags.empty?
    regist_tag(tags, true)
    pattern = (swing_words + tag_words).map { |word| "【#{word}】" }.join('|')
    rename_title title.gsub(/#{pattern}/, '')
  end

  def end_tag_check
    that = self
    tag_list.each do |tag|
      new_title = that.title.gsub /#{tag}$/, ''
      next if new_title == that.title
      that = that.rename_title(new_title)
    end
    that
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


  #
  # title: タイトル
  # tags:  新規タグ
  #
  def self.regist_story(title,tags)
    title = fix_title(title,tags)
    find_or_create_by(title: title)
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
