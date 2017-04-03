namespace :sample do
  task :blog_insert => :environment do
    FactoryGirl.create(:blog_s2_log)
    FactoryGirl.create(:blog_morikinoko)
    FactoryGirl.create(:blog_ayamevip)
    FactoryGirl.create(:blog_elephant)
    FactoryGirl.create(:blog_mode_ss)
    FactoryGirl.create(:blog_yryr)
    p "#{Blog.count} Blog Created."
  end

  task :swing_insert => :environment do
    Swing.create(:wrong => 'シンデレシンデレラガールズ', :correct => 'デレマス')
    Swing.create(:wrong => 'モバマス', :correct => 'デレマス')
    Swing.create(:wrong => 'アイドルマスター', :correct => 'アイマス')
    Swing.create(:wrong => '艦隊これくしょん～艦これ～', :correct => '艦これ')
    Swing.create(:wrong => '男女など', :correct => '男・女')
    Swing.create(:wrong => 'ガールズ&パンツァー', :correct => 'ガルパン')

    p "#{Swing.count} Swing Created."
  end

  task :faker_insert => :environment do
    10.times do |i|
      blog = Blog.create(
          :title => "TitleSokuho#{i}",
          :url => Faker::Internet.url,
          :rss => "#{Faker::Internet.url}/rss"
      )
      puts i
      1000.times do |j|
        blog.articles.create(
            :title => "#{Faker::Food.ingredient} #{j}",
            :url => Faker::Internet.url,
            :posted_at => Faker::Time.between(2.years.ago, Date.today, :all)
        )
      end
    end
  end

  task :user_insert => :environment do
    AdminUser.create!(email: 'sample@cps.im.dendai.ac.jp', password: 'password', password_confirmation: 'password')
    AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password')
  end
  #
  # task :test_a => :environment do
  #   p 'aaaaaa'
  # end
  #
  # task test_b => :environment do
  #   p 'bbbbbb'
  # end
  #
  # task :test => :environment do
  #   p 'rails sample:test_a'
  #   p 'rails sample:test_b'
  # end

end
