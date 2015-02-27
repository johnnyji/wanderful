require 'open-uri'

class Post < ActiveRecord::Base
	# adds a constant for uri regex
	URI_REGEX = /\A(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,20}(:[0-9]{1,5})?(\/.*)?\z/i
	acts_as_votable #voting
	acts_as_taggable #tagging

	belongs_to :user
	has_many :comments
	has_attached_file :image, styles: { medium: "750x500#", thumb: "250x250#" }, default_url: "/images/:style/missing.png"

	#gets image using MetaInspector before the post saves
	before_save :get_image_from_link, if: ->(post) { post.link_changed? }

	before_validation :format_url

  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
  validates_presence_of :title, :link, :description
  validates_format_of :link, with: URI_REGEX
  validate :check_link

  #search field input
  scope :search, lambda { |search_terms| where(["lower(title) like ?", "%#{search_terms.downcase}%"]) }

  def format_url
  	self.link = "http://#{self.link}" unless link =~ /^http/   
	end

	private

	def check_link
		begin
			@page_link = MetaInspector.new(link)
		rescue Faraday::ConnectionFailed => e
			errors.add(:link, 'is not valid')
		end
	end

	#defines the MetaInspector method
	def get_image_from_link
		page = @page_link
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
