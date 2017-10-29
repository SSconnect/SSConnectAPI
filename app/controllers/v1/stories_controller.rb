module V1
  class StoriesController < Grape::API
    after do
      header "X-Total",       @res.total_count.to_s
      header "X-Total-Pages", @res.total_pages.to_s
      header "X-Page",        @res.current_page.to_s
      header "X-Next-Page",   @res.next_page.to_s
      header "X-Prev-Page",   @res.prev_page.to_s

      header 'Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content-Type, Accept, X-Total, X-Total-Pages, X-Page, X-Next-Page, X-Prev-Page'
      header 'Access-Control-Expose-Headers', 'Origin, X-Requested-With, Content-Type, Accept, X-Total, X-Total-Pages, X-Page, X-Next-Page, X-Prev-Page'

    end

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
        @res = stories.includes(articles: [:blog]).order('first_posted_at DESC').page(params[:page])
        present @res, with: Entity::StoryEntity
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
