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

  def regist_tags(tags)
    return self if tags.empty?
    self.tag_list = self.tag_list.concat(tags.map { |tag| Swing.trans(tag.tr('SS', '')) })
    save
    self
  end

  # 新しい title の Story の作成または既存の Story へ Merge する
  def rename_title(title)
    return if title == self.title
    story = Story.find_or_create_by(title: title)
    story.articles += articles
    story.regist_tags(tag_list)
    destroy
    story
  end

  def bracket_words
    (title.scan /【(.*?)】/).flatten
  end

  def self.remove_bracket_all(tag)
    word_bra = "【#{tag}】"
    Story.where("title like '%#{word_bra}%'").each do |story|
      title = story.title.gsub word_bra, ''
      story.regist_tags([tag])
      story.rename_title(title)
    end
  end


  #
  # title: タイトル
  # tags:  新規タグ
  #
  def self.regist_story(title, tags)
    title = fix_title(title, tags)
    find_or_create_by(title: title).regist_tags(tags)
  end

  def self.fix_title(title, tags)
    title = space_delete(remove_bracket_filter(title, tags))
    title
  end

  def self.remove_bracket_filter(title, tags)
    wrong_words = bracket_words_2(title).select { |word| Swing.include? word }
    # Tag check
    tag_words = bracket_words_2(title).select { |word| !ActsAsTaggableOn::Tag.find_by_name(word).nil? }
    my_bracket_words = Bracket.bra_list
    pattern = (wrong_words + tag_words + tags +my_bracket_words).map { |word| "【#{word}】" }.join('|')
    title.gsub(/#{pattern}/, '')
  end

  def self.bracket_words_2(title)
    (title.scan /【(.*?)】/).flatten
  end

  # 文字一文字目の空白削除
  def self.space_delete(title)
    if (title.first == ' ') || (title.first == '　')
      title.slice!(0)
    end
    title
  end

end
