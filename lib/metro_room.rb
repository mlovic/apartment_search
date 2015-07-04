#$:.unshift File.dirname(__FILE__)
#$:.unshift File.expand_path(File.dirname(__FILE__)
$:.unshift File.expand_path(File.join(File.dirname(__FILE__), '../lib'))
require 'logger'
require 'pp'
require 'matrix'
require 'haversine'

require 'metro_room/init'
require 'metro_room/property'
require 'metro_room/idealista_parser'
require 'metro_room/location'
require 'metro_room/idealista'
require 'metro_room/metro_db'
require 'metro_room/configuration'
require 'metro_room/spike_arrest_error'
#require '../config'

# TODO configuration file

module MetroRoom
  extend self # what is this exactly?
  def self.root
    File.expand_path("..", File.dirname(__FILE__))
  end

  class << self
    attr_accessor :metro_db
    # Best practice?
  end

  def self.get_properties_from_line(query, line)
    init_db
    bocas = self.metro_db.get_bocas_from_line(line) # need self. ?
    properties = []
    bocas.each do |boca|
      properties.push(*get_properties_from_boca(query, boca))
    end
    return properties
  end
  
  def init_db
    self.metro_db ||= MetroDB.new(MetroRoom.configuration.db_host,
                           MetroRoom.configuration.db_user,
                           MetroRoom.configuration.db_password,
                           MetroRoom.configuration.db_name)
  end

  def get_properties_from_boca(query, boca)
    failed_once ||= false
    json = Idealista.request(query, boca.location)
    return IdealistaParser.get_listings(json)
  rescue SpikeArrestError
    unless failed_once
      failed_once = true
      sleep 1.5
      retry
    end
    raise
  end
    
  def self.get_properties(query, estacion)
    metro_db ||= MetroDB.new(MetroRoom.configuration.db_host,
                           MetroRoom.configuration.db_user,
                           MetroRoom.configuration.db_password,
                           MetroRoom.configuration.db_name)
    # TODO replace MetroDB.new args with hash and add get method to Config class
    bocas = metro_db.get_bocas_from_estacion(estacion)
    # TODO finish this for multiple bocas
    #$log.info "Bocas: #{boca.estacion} - #{boca.salida}"
    $log.info "Bocas: #{bocas.inspect}"
    boca = bocas.first

    json = Idealista.request(query, boca.location)
    properties = IdealistaParser.get_listings(json)

    return properties
    #TODO finish this, filter properties
  end

  def self.print_properties(query, estacion)
    json = Idealista.request(query)
    properties = IdealistaParser.get_listings(json)

    metro_db = MetroDB.new(MetroRoom.configuration.db_host,
                           MetroRoom.configuration.db_user,
                           MetroRoom.configuration.db_password,
                           MetroRoom.configuration.db_name)
    # TODO replace MetroDB.new args with hash and add get method to Config class
    bocas = metro_db.get_bocas_from_estacion(estacion)
    boca = bocas.first

    properties.each do |prop|
      prop.print(boca.location)
    end
  end
end


#MetroRoom.initialize

#TODO haversine patch raise argumenterror
# TODO DSL - see rubymonk instance eval bottom
# TODO array map instead of #each

