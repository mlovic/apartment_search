require_relative 'location'

class Boca
  attr_accessor :location, :estacion, :salida

  def initialize(location, estacion, salida)
    @location = location
    @estacion = estacion
    @salida = salida
  end

end
