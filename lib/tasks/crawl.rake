namespace :crawl do
  task :rss => :environment do
    Blog.all.each do |blog|
      p "#{blog.title}"
      blog.fetch_rss
    end
  end
end
