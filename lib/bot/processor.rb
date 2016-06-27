module Bot
  module Processor

    class Simple < Struct.new :json
      extend Forwardable
      attr_accessor :response

      #def before; end
      def after; end

      def safe_perform
        #before
        perform
        after
      rescue => e
        $logger.error e.message
        $logger.error e.backtrace
        self.response = \
        Bot::Views.response_message " 📛📛 error in processor #{self.class}" + "\n #{e.message} \n #{e.backtrace[0..2].join("\n")}", chat_id
      end

      def customer_data
        @customer_data ||= CustomerCacheData.find(chat_id) || {}
      end

      def chat_id
        json.dig "chat", "id"
      end
      private
        def ostruct_json; OpenStruct.new json; end
    end

  end
end
