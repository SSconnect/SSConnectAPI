# == Schema Information
#
# Table name: blogs
#
#  id         :integer          not null, primary key
#  title      :string
#  url        :string
#  rss        :string
#  selector   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Blog < ApplicationRecord
  has_many :articles

  def fetch_rss
    # RSS 未登録はスキップ
    return if rss.nil?
    feed = Feedjira::Feed.fetch_and_parse(blog.rss)
    feed.entries.each do |entry|
      new_entry(entry)
    end
  end

  def new_entry(entry)
    next if Article.where(url: entry.url).exists? # 登録済みチェック
    next if entry.title.has_emoji # NOTE: 絵文字チェック
    doc = Nokogiri::HTML(open(entry.url))
    next if doc.css(blog.selector)[0].nil? # TODO: Notification Selector invalid Erorr

    # あやめ速報のみ
    tags = doc.css('dd a').map(&:text) if blog.id == 3
    tags ||= [doc.css(blog.selector)[0].text]

    Article.create_with_story_from_entry(self, entry, tags)
  end
end
