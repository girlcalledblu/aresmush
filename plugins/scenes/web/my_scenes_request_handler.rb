module AresMUSH
  module Scenes
    class MyScenesRequestHandler
      def handle(request)
        enactor = request.enactor
        
        error = Website.check_login(request)
        return error if error
        
        my_scenes = Scene.all.select { |s| !s.completed && Scenes.is_watching?(s, enactor) }.sort_by { |s| s.id }
        
        my_scenes.each do |scene|
          scene.mark_read(enactor)
        end
        
        my_scenes.map { |s|
          Scenes.build_live_scene_web_data(s, enactor)
        }
        
      end
    end
  end
end

