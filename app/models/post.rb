class Post < ActiveRecord::Base
	acts_as_votable #gem for voting
	belongs_to :user
	has_many :comments
	has_attached_file :image, styles: { medium: "750x500#", thumb: "250x250#" }
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
  validates_presence_of :title, :link, :description
end
