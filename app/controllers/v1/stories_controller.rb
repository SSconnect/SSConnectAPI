module V1
  class StoriesController < ApplicationController
    before_action :set_entity, only: [:show]

    # articles GET
    # show_all_article
    def index
      page = (params[:page] || 1).to_i
      q = params[:q] || ''
      tag = params[:tag] || ''

      stories = q == '' ? Story.all : Story.where('title LIKE ?', "%#{q}%")
      stories = stories.tagged_with(tag) if tag != ''

      res = stories.includes(articles: [:blog]).order('first_posted_at DESC').page(page)
      render json: res, include: [{articles: [:blog]}], each_serializer: V1::StorySerializer
    end

  end
end
