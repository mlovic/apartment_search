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
    @obj["elementList"].each do |prop|
      prop = Property.new(prop["latitude"], prop["longitude"], prop["price"], prop["address"], prop["url"])
      properties << prop
    end
    $log.info "#{properties.size} properties parsed: #{properties.first.address}."
    return properties
  rescue StandardError => e  
    puts e.message  
    puts e.backtrace.inspect  
    puts @obj.class.name
    $log.error "error: #{e.message}"
    $log.error "backtrace: #{e.backtrace.inspect}"
    $log.error "obj: #{@obj.inspect}"
    #if @obj[:fault][:faultstring] == "Spike arrest violation. Allowed rate : 1ps"
      #puts "ERR: spike arrest violation"
      ##TODO use test_data, write exception type
      #puts e.backtrace.inspect  
    #end
  end

end
