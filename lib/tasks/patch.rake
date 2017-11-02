namespace :patch do
  desc "Remove story don't has article"
  task :remove_story_no_article => :environment do
    Story.includes(:articles).each do |story|
      next if story.articles.size > 0
      story.destroy
      p "Remove #{story.title}"
    end
  end

  # ゆるゆりSS速報のarticleを削除
  task :remove_article_yryr => :environment do
    blog = Blog.find_by(title: 'ゆるゆり速報')
    ac = Article.count
    sc = Story.count

    blog.destroy()

    delete_article_count = ac - Article.count
    delete_story_count = sc - Story.count
    p "#{delete_article_count}個のarticleを削除して、"
    p "#{delete_story_count}個のstoryを削除した"
  end
end