$:.unshift File.dirname(__FILE__)

require 'sinatra'
require 'json'
require 'lib/metro_room'
require 'pry'
require 'pry-byebug'
require 'tilt/erubis'
require 'pp'


#set :dump_errors, false

MetroRoom.configure do |config|
  config.db_host      = 'localhost'
  config.db_user      = 'root'
  config.db_password  = 'mysql05'
  config.db_name      = 'apartment_search'

  config.api_key      = 'EzWE6qNgjSFTEs4plajIvMzmrm5DOset'

  config.logger_stdout = true
  config.logger_level  = 'DEBUG'
end

MetroRoom.init

  $metro_db = MetroDB.new(MetroRoom.configuration.db_host,
                          MetroRoom.configuration.db_user,
                          MetroRoom.configuration.db_password,
                          MetroRoom.configuration.db_name)
  p $metro_db

  $client = Idealista::Client.new("EzWE6qNgjSFTEs4plajIvMzmrm5DOset")

    $query = {:country => "es",
             :max_items => 50,
             :num_page => 1,
             :distance => 800,
             :center => "40.4229014,-3.6976351",
             :property_type => "bedrooms",
             :operation => "A",
             :order => "distance",
             :sort => "asc",
             :max_price => 800,
             }

estacion = "Tribunal"

def convert_to_json(properties)
  prop_arr = []
  properties.each do |p|
    prop_arr << { address: p.address, 
                  latitude: p.latitude, 
                  longitude: p.longitude,
                  url: p.url }
  end
  json = JSON.generate(prop_arr)
  return json
end

get '/line/:line/:max_items'do
  begin
    bocas = $metro_db.get_bocas_from_line(params['line'])
    properties = bocas.flat_map do |boca|
      $query[:center] = boca.location.to_s
      ppp = $client.search($query)
      puts 'searching...'
      pp ppp
    end
    logger.info "#{properties.size} properties received..."
    $json = convert_to_json(properties)
    erb :index
  rescue SpikeArrestError => e
    erb :spike_arrest
  end
end

get '/:station/:max_items' do
  begin
    boca = $metro_db.get_bocas_from_estacion(params['station']).first
    $query[:center] = boca.location.to_s
    properties = $client.search($query)
    logger.info "#{properties.size} properties received..."
    $json = convert_to_json(properties)
    erb :index
  rescue SpikeArrestError => e
    erb :spike_arrest
  end
end

#TODO handle several bocas
