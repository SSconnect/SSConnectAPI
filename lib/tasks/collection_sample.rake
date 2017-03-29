namespace :collection_sample do
  task :blog_name => :environment do
    blog = Blog.find(0) # Blog Name
    url_base = 'http://host.com/?p='
    get_articles = lambda { |a| a.css('.article') }
    get_link = lambda { |a| a.css('h1 > a').attr('href').value }
    get_title = lambda { |a| a.css('h1 > a').text }
    get_ts = lambda { |a| a.css('time').attr('datetime').value }
    get_tag = lambda { |a| a.css('.article-category1 a').text }
    ts_format = '%Y-%m-%dT%H:%M:%S%z'
    CrawlUtil.run(blog, url_base, get_articles, get_title, get_link, get_tag, get_ts, ts_format)
  end
end
