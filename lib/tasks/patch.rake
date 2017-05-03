namespace :patch do
  desc "Remove story don't has article"
  task :remove_story_no_article => :environment do
    Story.includes(:articles).each do |story|
      next if story.articles.size > 0
      story.destroy
      p "Remove #{story.title}"
    end
  end
end