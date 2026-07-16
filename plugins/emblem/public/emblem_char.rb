module AresMUSH
  class Character
    attribute :emblem


    def self.derive_emblem(char)
      if Global.read_config('emblem', 'field_type') == "Demographic"
        field = Global.read_config('emblem', 'field')
        demographic = char.demographics[field]
        emblem = demographic
        return emblem
      elsif Global.read_config('emblem', 'field_type') == "Group"
        field = Global.read_config('emblem', 'field')
        group = char.groups[field]
        emblem = group
        return emblem
      elsif Global.read_config('emblem', 'field_type') == "Custom"
        emblem = char.emblem
        return emblem
      else

      end
    end
  end  
end