module Entity
  class ArticleEntity < Grape::Entity
    expose :id
    expose :url
    expose :blog,using: BlogEntity
    expose :created_at
    expose :updated_at
  end
end