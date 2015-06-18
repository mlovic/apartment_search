$:.unshift File.dirname(__FILE__)

require 'json'

require 'property' #necessary?

class IdealistaParser
  def initialize(json = nil)
  end

  #TODO fix this

  def self.get_listings(json)
    @obj = JSON.parse(json)
    properties = []
    begin
      @obj["elementList"].each do |prop|
        prop = Property.new(prop["latitude"], prop["longitude"], prop["price"], prop["address"])
        properties << prop
      end
      return properties
    rescue Exception => e  
      puts e.message  
      puts e.backtrace.inspect  
      #TODO use test_data, write exception type
      puts "Error parsing response body:\n\n"
      #pp @obj
      exit
    end
  end

end
