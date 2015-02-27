class Tag < ActiveRecord::Base
	#search field input
	scope :search, lambda {|search_terms| where(["lower(name) like ?", "%#{search_terms.downcase}%"])}
end
