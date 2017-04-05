module V1
  class BlogsController < Grape::API
    # def index
    #   blogs = Blog.all
    #   render json:blogs, each_siliarizer:V1::BlogSerializer,root:nil
    # end
    # def show
    #   render json:@blog, sirializer:V1::BlogSerializer, root:nil
    # end
    # private
    # def set_entity
    #   @blog = Blog.find(params[:id])
    # end
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
