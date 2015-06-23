$:.unshift File.dirname(__FILE__)

require 'lib/metro_room'

MetroRoom.configure do |config|
  config.db_host      = 'localhost'
  config.db_user      = 'root'
  config.db_password  = 'mysql05'
  config.db_name      = 'apartment_search'

  config.api_key      = 'EzWE6qNgjSFTEs4plajIvMzmrm5DOset'

end

MetroRoom.init #just put self.init outside of method?

query = {"apikey"   => MetroRoom.configuration.api_key,
         "country" => "es",
         "max_items" => 15,
         "numPage" => 1,
         "distance" => 60,
         "center" => "40.4229014,-3.6976351",
         "propertyType" => "bedrooms",
         "operation" => "A",
         "order" => "distance",
         "sort" => "asc"
        }
estacion = "Chueca"

properties = MetroRoom.print_properties(query, estacion)

$log.debug "MetroRoom mod used first time"
#TODO change $log to not be global variable.

#TODO handle several bocas
