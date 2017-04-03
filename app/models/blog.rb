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
      # SKIP 登録済み
      next if Article.where(url: entry.url).exists?
      # HACK: SKIP 絵文字入り
      next if entry.title.has_emoji
      doc = Nokogiri::HTML(open(entry.url))
      next if doc.css(blog.selector)[0].nil? # TODO: Notification Selector invalid Erorr
      if blog.id == 3
        tags = doc.css('dd a').map(&:text)
      end
      tags ||= [doc.css(blog.selector)[0].text]
      story = Story.regist_story(entry.title, tags)
      story.articles.create(url: entry.url,
                            posted_at: entry.last_modified,
                            blog: blog
      )
    end
  end
end
