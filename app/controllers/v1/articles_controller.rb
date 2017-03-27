module V1
  class ArticlesController < ApplicationController

    # articles GET
    # show_all_article
    def index
      p = (params[:page] || 1).to_i

      if params[:blog_id].nil?
        articles = Article.all
      else
        articles = Blog.find(params[:blog_id]).articles
      end

      unless params[:q].nil?
        articles = articles.where('title LIKE ?', "%#{params[:q]}%")
      end

      unless params[:story_id].nil?
        articles = Story.find(params[:story_id]).articles
      end

      res = articles.includes(:blog).order('posted_at DESC').page(p)
      render json: res, each_serializer: V1::ArticleSerializer
    end
  end
end