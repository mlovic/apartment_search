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
        prop = Property.new(prop["latitude"], prop["longitude"], prop["price"], prop["address"], prop["url"])
        properties << prop
      end
      $log.info "#{properties.size} properties parsed"
      return properties
    rescue Exception => e  
      $log.error "obj: #{@obj.inspect}"
      if @obj[:fault][:faultstring] == "Spike arrest violation. Allowed rate : 1ps"
        puts "ERR: spike arrest violation"
        #TODO use test_data, write exception type
      else
        puts e.message  
        puts e.backtrace.inspect  
      end
      #puts "Error parsing response body:\n\n"
      #pp @obj
      exit
    end
  end

end
