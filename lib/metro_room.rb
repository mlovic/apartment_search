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
#require '../config'

# TODO configuration file

#$log.info "Starting..."

module MetroRoom
  def self.get_properties(query, estacion)
    json = Idealista.request(query)
    properties = IdealistaParser.get_listings(json)

    metro_db = MetroDB.new(MetroRoom.configuration.db_host,
                           MetroRoom.configuration.db_user,
                           MetroRoom.configuration.db_password,
                           MetroRoom.configuration.db_name)
    # TODO replace MetroDB.new args with hash and add get method to Config class
    bocas = metro_db.get_bocas_from_estacion(estacion)
    return bocas
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

