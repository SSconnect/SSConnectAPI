namespace :patch do
  desc "Remove story don't has article"
  task :remove_story_no_article => :environment do
    Story.includes(:articles).each do |story|
      next if story.articles.size > 0
      story.destroy
      p "Remove #{story.title}"
    end
  end

  task :remove_yuruyuri_blog => :environment do
    Story.includes(:articles).each do |story|
      story.articles.each do |article|
        if article.blog.title == 'ゆるゆりSS速報'
          article.destroy!
        end
      end
      if story.articles.size == 0
        story.destroy
      end
      p "Remove #{story.title}"
    end
  end
end