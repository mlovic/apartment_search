module MetroRoom
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  class Configuration
    attr_accessor :db_host, :db_user, :db_password, :db_name
    attr_accessor :api_key
    attr_accessor :logger_stdout, :logger_level

    def initialize
      puts 'initilizing config obj'
    end
  end
end
