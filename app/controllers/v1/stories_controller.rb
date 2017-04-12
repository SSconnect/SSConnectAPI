module V1
  class StoriesController < Grape::API
    resource :stories do
      desc 'GET /stories'
      params do
        optional :page, type: Integer, default: 1
        optional :q, type: String, default: ''
        optional :tag, type: String, default: ''
      end
      get do
        stories = params[:q] == '' ? Story.all : Story.where('title LIKE ?', "%#{params[:q]}%")
        stories = stories.tagged_with(params[:tag]) if params[:tag] != ''
        res = stories.includes(articles: [:blog]).order('first_posted_at DESC').page(params[:page])
        present res, with: Entity::StoryEntity
      end
      
      desc 'GET /stories/:id'
      params do
        requires :id, type: Integer, desc: 'story id.'
      end
      route_param :id do
        get do
          Story.find(params[:id])
        end
      end
    end
  end
end
