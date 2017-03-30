namespace :crawl do
  task :rss => :environment do
    Blog.all.each do |blog|
      # rss未設置
      next if blog.rss.nil?
      puts blog.title
      feed = Feedjira::Feed.fetch_and_parse(blog.rss)
      feed.entries.each do |entry|
        # SKIP 登録済み
        next if Article.where(url: entry.url).exists?
        # HACK: SKIP 絵文字入り
        next if entry.title.each_char.select { |c| c.bytes.count >= 4 }.length > 0
        story = Story.find_or_create_by(title: entry.title)
        story.articles.create(url: entry.url,
                              posted_at: entry.first_posted_at,
                              blog: blog
        )

        doc = Nokogiri::HTML(open(entry.url))
        next if doc.css(blog.selector)[0].nil? # TODO: Notification Selector invalid Erorr
        if blog.id == 3
          tags = doc.css('dd a').map(&:text)
        end
        tags ||= doc.css(blog.selector)[0].text
        story.regist_tag(tags)
        story.bracket_check
      end

    end
  end
end
