$:.unshift File.dirname(__FILE__)

require 'json'

require 'property' #necessary?
require 'spike_arrest_error' #necessary?

class IdealistaParser
  def initialize(json = nil)
  end

  #TODO fix this
  #
  #TODO log metadata from end of json
  # TODO avoid making obj class var?

  def self.get_listings(json)
    @obj = JSON.parse(json)
    properties = []
    check_spike_arrest(@obj)
    raise StandardError, "ElementList not present?" unless @obj.has_key?("elementList")
    @obj["elementList"].each do |prop|
      properties << Property.new(prop["latitude"], 
                          prop["longitude"], 
                          prop["price"], 
                          prop["address"], 
                          prop["url"])
    end
    $log.info "#{properties.size} properties parsed: #{properties.first.address}."
    $log.info "Total properties: #{total_properties}."
    return properties
  rescue StandardError => e  
    #raise e if e.is_a?(SpikeArrestError)
    raise
    #puts e.message  
    ##puts e.backtrace.inspect  
    #puts @obj.class.name
    #$log.error "error: #{e.message}"
    #keys = []
    #@obj.each_key { |k| keys << k }
    #$log.info "keys: #{keys.join(', ')}"
    #binding.pry
    #if @obj[:fault][:faultstring] == "Spike arrest violation. Allowed rate : 1ps"
      #puts "ERR: spike arrest violation"
      ##TODO use test_data, write exception type
      #puts e.backtrace.inspect  
    #end
  end

    def self.total_properties
      @obj["total"]
    rescue StandardError { $log.warn "Total listings unknown" }
    end
    private_class_method :total_properties # WHY?

    def self.check_spike_arrest(obj)
      if obj["fault"] and (obj["fault"]["faultstring"] == "Spike arrest violation. Allowed rate : 1ps") # Remove brackets?
       $log.warn "Going to raise spike arrest!"
        raise SpikeArrestError, "Spike arrest violation"
      end
    rescue NoMethodError
      $log.error "Unknown response fault"
      raise
    end
    private_class_method :check_spike_arrest # WHY?

end
