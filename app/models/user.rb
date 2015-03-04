class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # extend FriendlyId
  # friendly_id :username
  
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy

  acts_as_follower
  acts_as_followable

  # anytime you save a user, check for @ then remove if @ is present
  before_save :check_username

  # adding user image using paperclip
  has_attached_file :image, styles: { medium: "200x200#", thumb: "50x50#"}, :default_url => ActionController::Base.helpers.asset_path('missing_:style.png')
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/

  # search
  scope :search, lambda {|search_terms| where(["lower(username) like ?", "%#{search_terms.downcase}%"])}

  def check_username
    self.username.gsub!(/^\@*/, "")
    # CHECKS IF THE USERNAME HAS ANY PUNCTUATIONS OR SPACES, IF IT DOESNT, RAISE ERROR 
  end
end
