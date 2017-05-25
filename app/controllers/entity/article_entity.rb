module Entity
  class ArticleEntity < Grape::Entity
    expose :id
    expose :url
    expose :posted_at
    expose :blog, using: BlogEntity
  end
end