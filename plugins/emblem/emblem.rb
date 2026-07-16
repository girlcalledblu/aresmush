$:.unshift File.dirname(__FILE__)

module AresMUSH
  module Emblem
    def self.plugin_dir
      File.dirname(__FILE__)
    end
 
    def self.shortcuts
      Global.read_config("emblem", "shortcuts")
    end
    
    def self.achievements
      Global.read_config('emblem', 'achievements')
    end
 
    def self.get_cmd_handler(client, cmd, enactor)
      return nil if !cmd.root_is?("emblem")
      
      case cmd.switch
      when "set"
        return EmblemSetCmd
      when "remove"
        return EmblemRemoveCmd
      when nil
        return EmblemCmd
      end
      
      nil
    end
  end
end
