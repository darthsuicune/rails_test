class Location < ActiveRecord::Base
  attr_accessible :address, :expiredate, :latitude, :longitude, :name, :other, :type
end
