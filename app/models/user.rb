class User < ActiveRecord::Base
  attr_accessible :email, :name, :password, :surname, :role_id
  belongs_to :role
end
