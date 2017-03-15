namespace :collection_sample do
  task :blog_name => :environment do
    blog = Blog.find(0)
    url_base = 'http://host.com?p='
    # selector
    css_articles = '.text_box'
    css_title = 'h1 a'
    css_link = 'h1 a'
    css_ts = 'td:nth-of-type(3)'
    css_tag = 'tr:nth-of-type(3) a'
    ts_format = '%Y年%m月%d日 %H:%M'

    CrawlUtil.run(blog, url_base, css_articles, css_title, css_link, css_tag, css_ts, ts_format)
  end
end
