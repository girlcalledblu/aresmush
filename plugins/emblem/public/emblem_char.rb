module AresMUSH
  class Character
    attribute :emblem


    def self.derive_emblem(char)
      if Global.read_config('emblem', 'field_type') == "Demographic"

      elsif Global.read_config('emblem', 'field_type') == "Group"
      
      elsif Global.read_config('emblem', 'field_type') == "Custom"

      else

      end
    end
  end  
end