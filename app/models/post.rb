class Post < ActiveRecord::Base
	# adds a constant for uri regex
	URI_REGEX = /\A(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,20}(:[0-9]{1,5})?(\/.*)?\z/i
	acts_as_votable #gem for voting
	
	has_many :comments
	has_attached_file :image, styles: { medium: "750x500#", thumb: "250x250#" }
	belongs_to :user

	before_validation :format_url

  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
  validates_presence_of :title, :link, :description, :image
  validates_format_of :link, with: URI_REGEX

  def format_url
  	self.link = "http://#{self.link}" unless link =~ /^http/   
	end
end
