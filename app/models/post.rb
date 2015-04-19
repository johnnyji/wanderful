require "net/http"
require "uri"
require 'open-uri'
require 'twitter-text'

class Post < ActiveRecord::Base
	include Twitter::Extractor
	include Twitter::Autolink
	URI_REGEX = /\A(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,20}(:[0-9]{1,5})?(\/.*)?\z/i
	HASHTAG_REGEX = /(?:\s|^)(?:#(?!\d+(?:\s|$)))(\w+)(?=\s|$)/i
	acts_as_votable
	acts_as_taggable

	belongs_to :user
	has_many :comments
	has_attached_file :image, 
										styles: { medium: "700x480#", thumb: "250x250#" }, default_url: ActionController::Base.helpers.asset_path("/images/missing_:style.png")

	before_validation :format_url
  before_validation :check_url_existance
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
  validates_presence_of :title, :link, :description, message: "Post title can't be blank"
  validates_format_of :link, with: URI_REGEX
  validate :check_link
  before_save :get_image_from_link, if: ->(post) { post.link_changed? }

  #search field input
  scope :search, lambda { |search_terms| where(["lower(title) like ?", "%#{search_terms.downcase}%"]) }

 #  def link_valid?
	#   uri = URI.parse(self.link)
	#   uri.kind_of?(URI::HTTP)
	#   binding.pry
	# rescue URI::InvalidURIError
	# 	errors.add(:link, "That link isn't valid!")
	#   false
	# end

  def check_url_existance
    begin
    	response = Net::HTTP.get_response(URI(self.link))
    rescue SocketError => se
      errors.add(:link, "That link isn't valid!")
    end
  end

  def format_url
  	self.link = "http://#{self.link}" unless link =~ /^http/
	end

	def extract_tags
		extract_hashtags(self.description)
	end

	private

	def check_link
		begin
			@page_link = MetaInspector.new(link)
		rescue Faraday::ConnectionFailed => e
			errors.add(:link, "Sorry, link could not be processed.")
		end
	end

	def get_image_from_link
		page = @page_link
    binding.pry
		return unless page.images.best.present?

		if page.images.owner_suggested.present?
			open(page.images.owner_suggested) { |file| self.image = file }
		else
			open(page.images.best) { |file| self.image = file }
		end
	end

end
