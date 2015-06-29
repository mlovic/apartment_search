require 'mysql'

require 'boca'

class MetroDB
  def initialize(host, user, pass, db)
    @con = Mysql.new(host, user, pass, db)
  end

  def query(arg)
    @con.query(arg) # good practice?
  end
  
  def get_bocas_from_line(line)
    rs = @con.query("SELECT Y, X, estacion, salida FROM bocas_metro WHERE linea RLIKE \
                    '[[:<:]]#{line}[[:>:]]';")
    #rs = @con.query("SELECT Y, X, salida FROM bocas_metro LIMIT 10;") 
    $log.info "Retrieved #{rs.num_rows} rows from the database"
    raise RuntimeError, "No bocas retrieved for line #{line}" unless rs.num_rows >  0
    bocas = convert_to_bocas(rs)
    $log.info "Retrievedd #{bocas.size} bocas from the database"
    return bocas

    # TODO raise exception
    # TODO metro ligero support
    
  end

  def get_bocas_from_estacion(estacion)
    rs = @con.query("SELECT Y, X, salida FROM bocas_metro WHERE estacion='#{estacion}';")
    bocas = []
    rs.each_hash do |r|
      #TODO should be in bocas?
      loc = Location.new([r["Y"].to_f, r["X"].to_f])
      bocas << Boca.new(loc, estacion, r["salida"])
    end
    $log.info "Retrieved #{bocas.size} bocas from the database"
    return bocas
  end

  private

    def convert_to_bocas(rs)
      bocas = []
      rs.each_hash do |r|
        #TODO should be in bocas?
        loc = Location.new([r["Y"].to_f, r["X"].to_f])
        bocas << Boca.new(loc, r["estacion"], r["salida"])
      end
      return bocas
    end

  #TODO put db config here?
  #TODO replace MetroDB.new args with hash and add get method to Config class

end
