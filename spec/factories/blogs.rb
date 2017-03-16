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

FactoryGirl.define do
  factory :blog, :class => Blog do
    title { FFaker::NameJA.last_name + FFaker::NameJA.last_name + '速報' }
    url { FFaker::Internet.http_url }
    rss { "#{FFaker::Internet.http_url}/rss" }
    selector { '.article-category1 > a' }

    factory :blog_s2_log do
      title 'えすえすログ'
      url 'http://s2-log.com'
      rss 'http://s2-log.com/index.rdf'
      selector '.article-category1 > a'
    end

    factory :blog_morikinoko do
      title '森きのこ！'
      url 'http://morikinoko.com'
      rss 'http://morikinoko.com/index.rdf'
      selector '.article-category1 > a'
    end

    factory :blog_ayamevip do
      title 'あやめ速報'
      url 'http://ayamevip.com/'
      rss 'http://ayamevip.com/index.rdf'
      selector '.article-category > a'
    end

    factory :blog_elephant do
      title 'エレファント速報'
      url 'http://elephant.2chblog.jp/'
      rss 'http://elephant.2chblog.jp/index.rdf'
      selector '.iCategory > a:nth-of-type(2)'
    end

    factory :blog_mode_ss do
      title 'えすえすmode'
      url 'http://blog.livedoor.jp/mode_ss/'
      rss 'http://blog.livedoor.jp/mode_ss/index.rdf'
      selector '.title_table tr:nth-of-type(3) .time'
    end

    factory :blog_yryr do
      title 'ゆるゆりSS速報'
      url 'http://blog.livedoor.jp/kakusika767'
      rss ''
      selector ''
    end
  end
end
