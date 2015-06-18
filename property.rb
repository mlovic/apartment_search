require 'haversine'
require 'location'

class Property
  attr_accessor :latitude, :longitude, :price, :address
  def initialize(latitude = nil, longitude = nil, price = nil, address = nil)
    @price = price
    @latitude = latitude
    @longitude = longitude
    @address = address
    if latitude and longitude
      @location = Location.new([latitude, longitude])
    else
      @location = nil
    end
  end

  def coordinates
    [@latitude, @longitude]
  end

  def distance(coord)
    Haversine.distance(coord, @location.coordinates).to_m
  end

  def print(location) # = nil
    raise ArgumentError unless location.class.name == NilClass or Location
    format = "dist: %-3dm %24s %5d %s"
    puts format % [distance(location.coordinates).round(0), coordinates.join(", "), @price, @address]
  end

  #TODO distance as instance variable?

end
