module Entity
  class ArticleEntity < Grape::Entity
    expose :id
    expose :url
    expose :blog,using: BlogEntity
  end
end