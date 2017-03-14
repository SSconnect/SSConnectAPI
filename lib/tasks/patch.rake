namespace :patch do
  task :change_posted_at => :environment do
    stories = Story.all
    stories.each do |story|
      story.last_posted_at = story.articles.map(&:posted_at).min
      story.save
    end
  end
end