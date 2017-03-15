class CrawlUtil
  def self.run(blog, url_base, selector_articles, selector_title, selector_link, selector_tag, selector_ts, ts_format)

    counter = Article.count

    10000.times do |i|
      url = url_base + i.to_s

      doc = Nokogiri::HTML(open(url))
      sleep(2)
      articles = doc.css(selector_articles)

      break if articles.count == 0 # finish

      articles.each do |article|
        url = article.css(selector_link).attr('href').value
        title = article.css(selector_title).text
        posted_at_complex = article.css(selector_ts).text
        posted_at = Time.strptime(posted_at_complex, ts_format)
        tag = article.css(selector_tag).text

        next unless Article.find_by_url(url).nil? # skip duplicate

        Article.create_with_story(url, posted_at, blog, title, tag)
        counter += 1
      end
      p counter
    end
  end

end
