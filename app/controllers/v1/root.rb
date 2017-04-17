module V1
  class Root < Grape::API
    content_type :json, 'application/json; charset=utf-8;'
    version 'v1', :using => :path
    format :json

    after do
      header "X-Total",       @res.total_count.to_s
      header "X-Total-Pages", @res.total_pages.to_s
      header "X-Page",        @res.current_page.to_s
      header "X-Next-Page",   @res.next_page.to_s
      header "X-Prev-Page",   @res.prev_page.to_s
    end

    mount V1::ArticlesController
    mount V1::BlogsController
    mount V1::StoriesController
    mount V1::TagsController
  end
end