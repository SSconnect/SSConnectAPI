module V1
  class TagsController < ApplicationController
    def index
      tags = ActsAsTaggableOn::Tag.order('taggings_count DESC')
      render json: tags, each_serializer: V1::TagSerializer
    end
  end
end
