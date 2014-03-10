# == Schema Information
#
# Table name: locations
#
#  id         :integer          not null, primary key
#  latitude   :float
#  longitude  :float
#  name       :string(255)
#  address    :string(255)
#  other      :string(255)
#  type       :string(255)
#  expiredate :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Location < ActiveRecord::Base
  attr_accessible :address, :expiredate, :latitude, :longitude, :name, :other, :type
end
