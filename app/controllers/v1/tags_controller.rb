module V1
  class TagsController < Grape::API
    content_type :json, 'application/json; charset=utf-8;'
    version 'v1', using: :path
    format :json
    resource :tags do
      desc 'GET /tags'
      get do
        ActsAsTaggableOn::Tag.order('taggings_count DESC')
      end
      desc 'GET /tags/:id'
      params do
        requires :id, type: Integer, desc: 'story id.'
      end
      route_param :id do
        get do
          ActsAsTaggableOn::Tag.all.find(params[:id])
        end
      end
    end
  end
end
