module MetroRoom
  extend self

  def self.init

    self.init_log

  end

  #TODO just put self.init outside of method?
  
  def init_log
    if configuration.logger_stdout
      $log = Logger.new(STDOUT)
    else
      $log = Logger.new(File.new("application.log",'w'))
    end
    $log.formatter = proc do |severity, datetime, progname, msg|
      "#{severity[0..2]} #{datetime.strftime("%T")}: #{msg}\n"
    end
    if configuration.logger_level == 'DEBUG' 
      $log.level = Logger::DEBUG
    else
      $log.level = Logger::INFO
    end
    $log.debug "Initialized logger"
  end

end
