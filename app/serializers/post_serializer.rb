class PostSerializer < ActiveModel::Serializer
  attributes :id, :title, :link, :description
  has_many :comments

end
