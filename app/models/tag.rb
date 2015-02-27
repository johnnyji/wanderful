class Tag < ActiveRecord::Base

	scope :search, lambda {|search_terms| where(["lower(name) like ?", "%#{search_terms.downcase}%"])}
end
