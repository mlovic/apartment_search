module MetroRoom
  extend self

  def self.init

    self.init_log

  end

  #TODO just put self.init outside of method?
  
  def init_log
    $log = Logger.new(File.new("../application.log",'w'))
    $log.formatter = proc do |severity, datetime, progname, msg|
      "#{severity[0..2]} #{datetime.strftime("%T")}: #{msg}\n"
    end
    $log.level = Logger::DEBUG
    $log.debug "Initialized logger"
  end

end
