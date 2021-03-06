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
  has_many :articles, :dependent => :delete_all

  def fetch_rss
    # RSS 未登録はスキップ
    return if rss.nil? or rss.empty?
    feed = Feedjira::Feed.fetch_and_parse(rss); 0
    feed.entries.each do |entry|
      new_entry(entry)
    end
  end

  def new_entry(entry)
    return if Article.where(url: entry.url).exists? # 登録済みチェック
    return if entry.title.has_emoji? # NOTE: 絵文字チェック
    doc = Nokogiri::HTML(open(entry.url))
    return if doc.css(selector)[0].nil? # TODO: Notification Selector invalid Erorr

    # あやめ速報のみ
    tags = doc.css('dd a').map(&:text) if id == 3
    tags ||= [doc.css(selector)[0].text]

    Article.create_with_story_from_entry(self, entry, tags)
  end



  after_destroy do
    Story.left_outer_joins(:articles).where( articles: { id: nil } ).destroy_all()
  end

end
