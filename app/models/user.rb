class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me,
                  :firstname, :lastname, :is_admin, :email_notification, :language,
                  :preferences_attributes

  has_one :preferences, :class_name => "UserPreference"
  accepts_nested_attributes_for :preferences, :allow_destroy => false

  default_scope includes(:preferences)

  after_create  :initalize_settings

  # Validators
  validates_uniqueness_of :email
  validates_presence_of   :email, :firstname, :lastname

  def self.search(search)
    if search
      where('lastname LIKE ? OR firstname LIKE ? OR email LIKE ?', "%#{search}%", "%#{search}%", "%#{search}%")
    else
      scoped
    end
  end

private
  def initalize_settings
    p = UserPreference.new
    p.user_id = self.id
    p.save
  end
end
