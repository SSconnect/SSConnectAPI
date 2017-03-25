module V1
  class StoriesController < ApplicationController
    before_action :set_entity, only: [:show]

    # articles GET
    # show_all_article
    def index
      page = (params[:page] || 1).to_i
      q = params[:q] || ''
      # tagのt
      tag = params[:tag] || ''

      if q == ''
        stories = Story.all
      else
        stories = Story.where('title LIKE ?', "%#{q}%")
      end

      unless params[:tag].nil?
        stories = stories.tagged_with(tag)
      end

      res = stories.includes(articles: [:blog]).order('last_posted_at DESC').page(page)
      render json: res, include: [{articles: [:blog]}], each_serializer: V1::StorySerializer
    end

  end
end
