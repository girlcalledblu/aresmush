module AresMUSH
  module Emblem
    class EmblemRemoveCmd
      include CommandHandler
      
      attr_accessor :name
      
      def parse_args
        self.name = cmd.args
      end
      
      def required_args
        [ self.name ]
      end
      
      def handle
        result = ClassTargetFinder.find(self.name, Character, enactor)
        if (!result.found?)
          client.emit_failure result.error
          return
        end
        char_to_update = result.target

        char_to_update.update(emblem: nil)
        client.emit_success t('emblem.emblem_removed', :name => self.name)
      end
    end
  end
end
