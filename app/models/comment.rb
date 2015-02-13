class Comment < ActiveRecord::Base
  belongs_to :post
  belongs_to :user
  # Why won't this validation work...
  validates :content, presence: true
 end