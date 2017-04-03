namespace :collection do

  task :sslog => :environment do
    blog = Blog.find(1) # えすえすログ
    url_base = 'http://s2-log.com/?p='
    get_articles = lambda { |a| a.css('.article') }
    get_link = lambda { |a| a.css('h1 > a').attr('href').value }
    get_title = lambda { |a| a.css('h1 > a').text }
    get_ts = lambda { |a| a.css('time').attr('datetime').value }
    get_tags = lambda { |a| [a.css('.article-category1 a').text] }
    ts_format = '%Y-%m-%dT%H:%M:%S%z'
    CrawlUtil.run(blog, url_base, get_articles, get_title, get_link, get_tags, get_ts, ts_format)
  end

  task :mori => :environment do
    blog = Blog.find(2) # 森キノコ
    url_base = 'http://morikinoko.com/?p='
    get_articles = lambda { |a| a.css('.article-header-wrap') }
    get_title = lambda { |a| a.css('h1 a').text }
    get_link = lambda { |a| a.css('h1 a').attr('href').value }
    get_ts = lambda { |a| a.css('time').attr('datetime').value }
    get_tags = lambda { |a| [a.css('.article-category1').text] }
    ts_format = '%Y-%m-%dT%H:%M:%S%z'
    CrawlUtil.run(blog, url_base, get_articles, get_title, get_link, get_tags, get_ts, ts_format)
  end

  task :ayame => :environment do
    blog = Blog.find(3) # あやめ速報
    url_base = 'http://ayamevip.com/?p='
    get_articles = lambda { |a| a.css('div.article-header') }
    get_link = lambda { |a| a.css('a').attr('href').value }
    get_title = lambda { |a| a.css('.article-title a').text }
    get_ts = lambda { |a| a.css('span').text }
    get_tags = lambda { |a| a.css('dd a').map(&:text) }
    ts_format = '%Y年%m月%d日 %H:%M'
    CrawlUtil.run(blog, url_base, get_articles, get_title, get_link, get_tags, get_ts, ts_format)
  end

  task :elephant => :environment do
    blog = Blog.find(4) # エレファント速報
    url_base = 'http://elephant.2chblog.jp/archives/cat_50043605.html?p='
    get_articles = lambda { |a| a.css('.article') }
    get_link = lambda { |a| a.css('h2 > a').attr('href').value }
    get_title = lambda { |a| a.css('h2 > a').text }
    get_ts = lambda { |a| a.css('.iTime').text }
    get_tags = lambda { |a| [a.css('.iCategory a:nth-of-type(2)').text] }
    ts_format = '%Y年%m月%d日 %H:%M'
    CrawlUtil.run(blog, url_base, get_articles, get_title, get_link, get_tags, get_ts, ts_format)
  end

  task :ssmode => :environment do
    blog = Blog.find(5) # えすえすmode
    url_base = 'http://blog.livedoor.jp/mode_ss/?p='
    get_articles = lambda { |a| a.css('.text_box') }
    get_link = lambda { |a| a.css('h1 a').attr('href').value }
    get_title = lambda { |a| a.css('h1 a').text }
    get_ts = lambda { |a| a.css('td:nth-of-type(3)').text }
    get_tags = lambda { |a| [a.css('tr:nth-of-type(3) a').text] }
    ts_format = '%Y年%m月%d日 %H:%M'
    CrawlUtil.run(blog, url_base, get_articles, get_title, get_link, get_tags, get_ts, ts_format)
  end

  task :yryr => :environment do
    blog = Blog.find(6) # ゆるゆりSS速報
    url_base = 'http://blog.livedoor.jp/kakusika767/?p='
    get_articles = lambda { |a| a.css('div.article-header') }
    get_link = lambda { |a| a.css('a').attr('href').value }
    get_title = lambda { |a| a.css('.article-title a').text.strip }
    get_ts = lambda { |a| a.css('span').text }
    get_tags = lambda { |a| [a.css('dd:nth-of-type(1) a').text] }
    ts_format = '%Y年%m月%d日 %H:%M'
    CrawlUtil.run(blog, url_base, get_articles, get_title, get_link, get_tags, get_ts, ts_format)
  end
end
