module AresMUSH  

  module Migrations
    class Migration2x9x0Update
      def require_restart
        false
      end
      
      def migrate
        Global.logger.debug "Achievement notification cron."
        config = DatabaseMigrator.read_config_file("achievements.yml")
        config['achievements']['notification_cron'] = { 'hour' => [19], 'minute' => [30] }
        config['achievements']['notification_category'] = "System Notices"
        config['achievements']['notification_days'] = 1
        DatabaseMigrator.write_config_file("achievements.yml", config)
      end
    end
  end    
end