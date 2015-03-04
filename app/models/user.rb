class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # extend FriendlyId
  # friendly_id :username

  FORMAT_USERNAME_REGEX = /^\d*[a-zA-Z][a-zA-Z\d]*$/i

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy

  acts_as_follower
  acts_as_followable

  # anytime you save a user, check username for REGEX match
  before_save :remove_username_prefix

  # adding user image using paperclip
  has_attached_file :image, styles: { medium: "200x200#", thumb: "50x50#"}, :default_url => ActionController::Base.helpers.asset_path('missing_:style.png')
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/

  scope :search, lambda {|search_terms| where(["lower(username) like ?", "%#{search_terms.downcase}%"])}


  def remove_username_prefix
    self.username.gsub!(/^\@*/i, "")
  end

  def check_username_format
    if self.username.match(FORMAT_USERNAME_REGEX)
      #username is valid
      return true
    else
      #username is invalid
      return false
    end
  end


end
