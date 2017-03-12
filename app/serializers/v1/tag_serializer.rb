module V1
  class TagSerializer < ActiveModel::Serializer
    attributes :id, :name, :count

    def count
      object.taggings_count
    end
  end
end
