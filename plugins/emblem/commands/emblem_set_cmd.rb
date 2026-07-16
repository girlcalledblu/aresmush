module AresMUSH
  module Emblem
    class EmblemSetCmd
      include CommandHandler
      
      attr_accessor :name, :emblem
      
      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        self.name = args.arg1
        self.emblem = args.arg2
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

        char_to_update.update(emblem: self.emblem)
        client.emit_success t('emblem.emblem_added', :name => self.name, :emblem => self.emblem)
      end
    end
  end
end
