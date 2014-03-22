# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  surname    :string(255)
#  email      :string(255)
#  password   :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  role_id    :integer
#

class User < ActiveRecord::Base
  attr_accessible :email, :name, :surname, :password, :password_confirmation
  has_many :microposts, dependent: :destroy
  
  has_secure_password

  before_save { email.downcase! }
  before_save :create_remember_token
  
  validates :name, presence: true, length: { maximum: 60 }
  
  VALID_EMAIL_FORMAT = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_FORMAT }, 
       uniqueness: { case_sensitive: false }
  
  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true
  
  after_validation { self.errors.messages.delete(:password_digest) }
  
  def feed
    Micropost.where("user_id = ?", id)
  end
  
  private
    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
end
