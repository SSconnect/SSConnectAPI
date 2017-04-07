module V1
  class ArticlesController < Grape::API
    content_type :json, 'application/json; charset=utf-8;'
    version 'v1', using: :path
    format :json
    resource :articles do
      desc 'article all'
      params do
        optional :page, type: Integer, default: 1
        optional :blog_id, type: Integer
        optional :story_id, type: Integer
      end
      get do
        if params[:blog_id].nil?
          articles = Article.all
        else
          articles = Blog.find(params[:blog_id]).articles
        end

        unless params[:story_id].nil?
          articles = Story.find(params[:story_id]).articles
        end
        res = articles.includes(:blog).order('posted_at DESC').page(params[:page])
        res
      end
      desc 'article(id)'
      params do
        requires :id, type: Integer, desc: 'story id.'
      end
      route_param :id do
        get do
          Article.find(params[:id])
        end
      end
    end
  end
end