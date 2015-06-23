require 'mysql'

require 'boca'

class MetroDB
  def initialize(host, user, pass, db)
    @con = Mysql.new(host, user, pass, db)
  end

  def get_bocas_from_estacion(estacion)
    rs = @con.query("SELECT Y, X, salida FROM bocas_metro WHERE estacion='#{estacion}';")
    bocas = []
    rs.each_hash do |r|
      #TODO should be in bocas?
      loc = Location.new([r["Y"].to_f, r["X"].to_f])
      boca = Boca.new(loc, estacion, r["salida"])
      bocas << boca
      $log.info "Retrieved #{bocas.size} bocas from the database"
    end
    return bocas
  end

  #TODO put db config here?
  #TODO replace MetroDB.new args with hash and add get method to Config class

end
