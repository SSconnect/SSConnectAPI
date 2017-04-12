module Entity
  class BlogEntity < Grape::Entity
    expose :id
    expose :title
    expose :rss
    expose :created_at
    expose :updated_at
  end
end