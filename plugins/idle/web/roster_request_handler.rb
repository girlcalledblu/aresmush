module AresMUSH
  module Idle
    class RosterRequestHandler
      def handle(request)
                
        gallery_group = Global.read_config("website", "character_gallery_group") || "Faction"
        group_config = Demographics.all_groups.select { |k, v| k.downcase == gallery_group.downcase }.values.first
        group_order = (( group_config["values"] || {} ).keys || []).map { |g| g.downcase }
        
        fields = Global.read_config("idle", "roster_fields").select { |f| f['field'] != 'name' }
        titles = fields.map { |f| f['title'] }
        
        roster = []
        
        groups = Character.all.select { |c| c.on_roster? }
          .group_by { |c| c.group(gallery_group) || "" }
          .sort_by { |group, chars| [group_order.find_index(group.downcase) || 99, group] }
        
        groups.each_with_index do |(group, chars), index|
          name = group.blank? ? "No #{gallery_group}" : group
          roster << {
            key: name.parameterize(),
            name: name,
            active_class: index == 0 ? "active" : "",
            chars: chars.sort_by { |c| c.name }.map { |c| build_profile(c, fields) }
          } 
        end
        
        {
          roster: roster,
          titles: titles
        }
      end
      
      def build_profile(char, field_config)
        demographics = {}
        Demographics.visible_demographics(char, nil).each { |d| 
            demographics[d.downcase] = char.demographic(d)
          }
        
        if (Ranks.is_enabled?)
          demographics['rank'] = char.rank
        end
          
        demographics['age'] = char.age
        demographics['birthdate'] = char.formatted_birthdate
        
        groups = {}
        
        Demographics.all_groups.keys.each { |g| 
          groups[g.downcase] = char.group(g)  
          }
        
        fields = {}
        field_config.each do |config|
          field = config["field"]
          title = config["title"]
          value = config["value"]

          fields[title] = Profile.general_field(char, field, value)
        end
          
          {
            name: char.name,
            id: char.id,
            profile_title: Ranks.is_enabled? ? Profile.profile_title(char) : char.fullname,
            fields: fields,
            icon: Website.icon_for_char(char),
            roster_notes: Website.format_markdown_for_html(char.roster_notes || ""),
            previously_played: char.roster_played,
            app_required: Idle.roster_app_required?(char),
            contact: char.roster_contact,
            groups: groups,
            demographics: demographics,
            app_pending: char.roster_job ? true: false
        }        
      end
      
    end
  end
end