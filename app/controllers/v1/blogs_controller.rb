module V1
  class BlogsController < Grape::API
    resource :blogs do
      desc 'GET /blogs'
      get do
        Blog.all
      end

      desc 'GET /blogs/:id'
      params do
        requires :id, type: Integer, desc: 'story id.'
      end
      route_param :id do
        get do
         @blog = Blog.find(params[:id])
        end
      end
    end
  end
end
