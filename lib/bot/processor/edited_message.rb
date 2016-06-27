require "#{APP_ROOT}/lib/bot/processor"

module Bot
  module Processor
    class EditedMessage < Simple

      def perform
        self.response = \
        Bot::Views::Simple.message chat_id: chat_id, text: "🔥🔥"
      end

    end
  end
end
