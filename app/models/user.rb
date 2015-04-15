class User < ActiveRecord::Base
  acts_as_follower
  acts_as_followable

  FORMAT_USERNAME_REGEX = /^\d*[a-zA-Z][a-zA-Z\d]*$/i

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_attached_file :image, styles: { medium: "200x200#", thumb: "50x50#"}, default_url: ActionController::Base.helpers.asset_path("/images/missing_:style.png")
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/, message: "You need a picture!"
  validates_uniqueness_of :username, message: "username is taken, try another!"
  validates_presence_of :username, message: "username can't be blank!"
  validates_presence_of :name, message: "name can't be blank!"

  # anytime you save a user, check username for REGEX match
  before_save :remove_username_prefix

  scope :search, lambda {|search_terms| where(["lower(username) like ?", "%#{search_terms.downcase}%"])}


  def remove_username_prefix
    username.gsub!(/^\@*/i, '')
  end

  def check_username_format
    self.username.match(FORMAT_USERNAME_REGEX)
  end


end
