$:.unshift File.dirname(__FILE__)
require 'logger'
require 'pp'
require 'matrix'
require 'haversine'

require 'property'
require 'idealista_parser'
require 'location'
require 'idealista'
require 'metro_db'

# TODO configuration file


$log = Logger.new(File.new("application.log",'w'))
$log.formatter = proc do |severity, datetime, progname, msg|
  "#{severity[0..2]} #{datetime.strftime("%T")}: #{msg}\n"
end
$log.level = Logger::DEBUG
$log.info "Starting..."

query = {"apikey"   => "EzWE6qNgjSFTEs4plajIvMzmrm5DOset",
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

json = Idealista.request(query)
properties = IdealistaParser.get_listings(json)

metro_db = MetroDB.new('localhost', 'root', 'mysql05', 'apartment_search')
bocas = metro_db.get_bocas_from_estacion(estacion)
#TODO handle several bocas
boca = bocas.first

properties.each do |prop|
  prop.print(boca.location)
end

#TODO haversine patch raise argumenterror

