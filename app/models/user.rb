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
  has_secure_password

  before_save { email.downcase! }
  
  validates :name, presence: true, length: { maximum: 60 }
  
  VALID_EMAIL_FORMAT = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_FORMAT }, 
       uniqueness: { case_sensitive: false }
  
  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true
  
end
