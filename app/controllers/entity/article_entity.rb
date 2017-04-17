module Entity
  class ArticleEntity < Grape::Entity
    expose :id
    expose :url
    expose :created_at
    expose :updated_at
    expose :blog,using: BlogEntity
  end
end