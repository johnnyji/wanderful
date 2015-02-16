require 'open-uri'

class Post < ActiveRecord::Base
	# adds a constant for uri regex
	URI_REGEX = /\A(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,20}(:[0-9]{1,5})?(\/.*)?\z/i
	acts_as_votable #gem for voting
	
	belongs_to :user
	has_many :comments
	has_attached_file :image, styles: { medium: "750x500#", thumb: "250x250#" }

	before_save :get_image_from_link, if: ->(post) { post.link_changed? }

	before_validation :format_url

  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
  validates_presence_of :title, :link, :description
  validates_format_of :link, with: URI_REGEX

  def format_url
  	self.link = "http://#{self.link}" unless link =~ /^http/   
	end

	private
	def get_image_from_link
		page = MetaInspector.new(link)
		#ends the method if the page doesnt have any images
		return unless page.images.best.present?

		if page.images.owner_suggested.present?
			open(page.images.owner_suggested) do |file|
				#self is not implied, so therefore you must declare self on a method, much like $(this) in jquery
				self.image = file
			end
		else
			open(page.images.best) do |file|
				#self is not implied, so therefore you must declare self on a method, much like $(this) in jquery
				self.image = file
			end
		end
	end
end
