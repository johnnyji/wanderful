class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :posts
  has_many :comments

  #adding user image using paperclip
  has_attached_file :image, styles: { medium: "200x200#", thumb: "50x50#"}, :default_url => ActionController::Base.helpers.asset_path('missing_:style.png')
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/

end
