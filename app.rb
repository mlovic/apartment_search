$:.unshift File.dirname(__FILE__)

require 'sinatra'
require 'json'
require 'lib/metro_room'
require 'pry'
require 'pry-byebug'

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

MetroRoom.init #just put self.init outside of method?

query = {"apikey"   => MetroRoom.configuration.api_key,
         "country" => "es",
         "maxItems" => 9999,
         "numPage" => 1,
         "distance" => 100,
         #"center" => "40.4229014,-3.6976351",
         "propertyType" => "bedrooms",
         "operation" => "A",
         "order" => "distance",
         "sort" => "asc",
         "maxPrice" => "300",
        }
estacion = "Tribunal"

def convert_to_json(properties)
  prop_arr = []
  properties.each do |p|
    prop_arr << { address: p.address, 
                  latitude: p.location.lat, 
                  longitude: p.location.long,
                  url: p.url }
  end
  json = JSON.generate(prop_arr)
  return json
end

get '/line/:line/:max_items'do
  begin
    query["maxItems"] = params['max_items']
    properties = MetroRoom.get_properties_from_line(query, params['line'])
    logger.info "#{properties.size} properties received..."
    $json = convert_to_json(properties)
    erb :index
  rescue SpikeArrestError => e
    erb :spike_arrest
  end
end

get '/:station/:max_items' do
  begin
    query["maxItems"] = params['max_items']
    properties = MetroRoom.get_properties(query, params['station'])
    logger.info "#{properties.size} properties received..."
    $json = convert_to_json(properties)
    erb :index
  rescue SpikeArrestError => e
    #e.message
    #e.backtrace
    erb :spike_arrest
  end
end

#TODO handle several bocas
