$:.unshift File.dirname(__FILE__)

require 'lib/metro_room'

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

#TODO handle several bocas
