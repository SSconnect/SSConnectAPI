module V1
  class ArticlesController < Grape::API
    content_type :json, 'application/json; charset=utf-8;'
    version 'v1', using: :path
    format :json
    resource :articles do
      desc 'article all'
      get do
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