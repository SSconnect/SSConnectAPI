class CrawlUtil
  def self.run(blog, url_base, get_articles, get_title, get_link, get_tag, get_ts, ts_format)

    counter = Article.count

    10000.times do |i|
      url = url_base + i.to_s

      doc = Nokogiri::HTML(open(url))
      sleep(2)
      articles = get_articles.call(doc)

      break if articles.count == 0 # finish

      articles.each do |a|
        url = get_link.call(a)
        title = get_title.call(a)
        posted_at_complex = get_ts.call(a)
        posted_at = Time.strptime(posted_at_complex, ts_format)
        tag = get_tag.call(a)

        next unless Article.find_by_url(url).nil? # skip duplicate

        Article.create_with_story(url, posted_at, blog, title, tag)
        counter += 1
      end
      p counter
    end
  end

end
