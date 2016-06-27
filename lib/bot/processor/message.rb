require "#{APP_ROOT}/lib/bot/processor"

module Bot
  module Processor

    # class for process messages from clients
    #
    class Message < Simple
      # delegate some methods to recieved message json
      def_delegators :ostruct_json, :message_id, :entities, :text, :date, :from
      def_delegator :ostruct_chat, :type, :chat_type
      def_delegator :ostruct_chat, :id, :chat_id

      # some aliases
      alias_method :id, :message_id
      alias_method :body, :text

      # process message from client
      def perform
        $logger.info " * processor/message/perform"

        # in_long_action mode: use previous schema
        #
        if false #todo: off states and cache #
        #if customer_data&.in_long_action
          schema(customer_data.last_action)
          #schema.continue
          # continue long action
          #   * check request to cancel action, then delete from cache "action"

        # schema available when customer put some command
        elsif schema
          $logger.info customer_data.inspect
          schema.start
          # new message, may be request for start action
          #   * create cache
        elsif available_cmd
          $logger.info msg="can't find available schema for command: #{available_cmd}!"
          self.response = Bot::Views::Simple.message chat_id: chat_id, text: msg
        else
          #$logger.info msg="message without known commands - do nothing"
          #self.response = Bot::Views::Simple.message chat_id: chat_id, text: msg
          #response =
        end
      end

      # return bot/action_route/schema instance object or nil
      def schema route=available_cmd
        if action_route_schema(route)
          @schema ||= action_route_schema(route).new(self)
        end
      end

      def action_route_schema route=available_cmd
        Bot::ActionRoute.get_schema_class available_cmd
      end

      def available_cmd
        @available_cmd ||= \
        commands.any? && commands.detect do |cmd|
          Bot::ActionRoute.available? cmd
        end

        if Bot::ActionRoute.is_alias? @available_cmd
          Bot::ActionRoute.get_route @available_cmd
        else
          @available_cmd
        end
      end

      def created_at
        DateTime.strptime date.to_s, '%s'
      end

      # parse commands from message body
      def commands
        @commands ||=
        (entities or []).map do |e|
          body[ e['offset']..(e['offset']+e['length']) ]
            .strip.downcase if e['type'] == 'bot_command'
        end.compact
      end

      private
        def ostruct_chat; OpenStruct.new json['chat']; end

    end
  end
end
