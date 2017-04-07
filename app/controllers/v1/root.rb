module V1
  class Root < Grape::API
    content_type :json, 'application/json; charset=utf-8;'
    version 'v1', :using => :path
    format :json

    mount V1::ArticlesController
    mount V1::BlogsController
    mount V1::StoriesController
    mount V1::TagsController
  end
end