require "#{APP_ROOT}/lib/bot/processor"

module Bot
  module Processor
    class CallbackQuery < Simple

      # delegate some methods to recieved callback object json
      def_delegators :message, :id, :data

      def perform
        #text = "Вам необходимо **#{}** ?".to_i
        # every flash
        #update_callback_message message.body.gsub(/\D/,'').to_i+(data == 'positive' ? 1000 : -1000)
        @response = Bot::Views.flash "~ + + + ~", id
      end

      def update_callback_message text
        Bot::API.exec "/editMessageText", chat_id: message.chat_id, message_id: message.id, text: text, :reply_markup=>{:inline_keyboard=>[[{:text=>"-", :callback_data=>"negative"}, {:text=>"+", :callback_data=>"positive"}]]}
      end

      #def chat_id; message["from"]["id"]; end

      private
        def message; Message.new json["message"]; end
    end
  end
end

