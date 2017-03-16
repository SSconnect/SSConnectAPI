module V1
  class ArticleSerializer < ActiveModel::Serializer
    attributes :id, :posted_at, :url

    has_one :blog, serealizer: BlogSerializer
    has_one :story, serealizer: StorySerializer
  end
end
