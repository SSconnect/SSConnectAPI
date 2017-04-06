module V1
  class BlogsController < Grape::API
    content_type :json, 'application/json; charset=utf-8;'
    version 'v1', using: :path
    format :json
    prefix :api
    resource :blogs do
      desc 'blog all'
      get do
        Blog.all
      end

      desc 'blog(id)'
      params do
        requires :id, type: Integer, desc: 'story id.'
      end
      route_param :id do
        get do
         @blog = Blog.find(params[:id])
         @blog
        end
      end
    end
  end
end
