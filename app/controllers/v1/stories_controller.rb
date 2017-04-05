module V1
  class StoriesController < Grape::API
    version 'v1', using: :path
    format :json
    prefix :api
    resource :stories do
      desc 'story all'
      get do
        page = (params[:page] || 1).to_i
        q = params[:q] || ''
        tag = params[:tag] || ''
        stories = q == '' ? Story.all : Story.where('title LIKE ?', "%#{q}%")
        stories = stories.tagged_with(tag) if tag != ''

        res = stories.includes(articles: [:blog]).order('first_posted_at DESC').page(page)
        res
      end
      
      desc 'story(id)'
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
