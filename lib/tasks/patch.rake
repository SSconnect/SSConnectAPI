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
    delete_article_count = 0
    delete_story_count = 0
    Story.includes(:articles).each do |story|
      articles_count = story.articles.size
      story.articles.each do |article|
        if article.blog.title == 'ゆるゆりSS速報'
          article.destroy
          articles_count -= 1
          p "#{article.blog.title}削除成功"
          delete_article_count += 1
        end
      end
      if articles_count == 0
        story.destroy
        p "Remove #{story.title}"
        delete_story_count += 1
      end
    end
    puts
    puts
    p "#{delete_article_count}個のarticleを削除して、"
    p "#{delete_story_count}個のstoryを削除した"
  end
end