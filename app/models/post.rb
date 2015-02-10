class Post < ActiveRecord::Base
	belongs_to :user
	has_many :comments
	has_attached_file :image, styles: { medium: "750x500#", thumb: "350x350>" }
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
end
