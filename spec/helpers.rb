module Helpers

  def default_configure
    MetroRoom.configure do |config|
      config.db_host      = 'localhost'
      config.db_user      = 'root'
      config.db_password  = 'mysql05'
      config.db_name      = 'apartment_search'

      config.api_key      = 'EzWE6qNgjSFTEs4plajIvMzmrm5DOset'

      config.logger_stdout = true
      config.logger_level  = 'DEBUG'
    end
  end

  def init_db
    metro_db = MetroDB.new(MetroRoom.configuration.db_host,
                           MetroRoom.configuration.db_user,
                           MetroRoom.configuration.db_password,
                           MetroRoom.configuration.db_name)
  end

  def mock_logging
    #TODO
  end

end
