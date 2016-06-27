module Bot
  module ActionRoute

    class DefaultSchema < Struct.new :processor

      # some decorate methods here
      #   :short schema with only one route, :long if else
      def short?; !long?; end
      def long?; Array === route; end
      def type; long? && :long || :short; end

      # > looking value from config/routes.yml
      def route; Map[current_action]; end

      # > default perform action in default schema
      def start
        $logger.info "#{self.class} .star: do someshit with: #{route}"
        #if short?
          ## short cat return response body
          #processor.response = send(route.to_sym)
        #else
        #end
        store_someshit!
        processor.response = send(current_step.to_sym)
      end

      def continue
        # do_som.. if valid?_
        #
        #   next_state or finish result
        #
      end

      def store_someshit!
        CustomerCacheData.store chat_id,
          in_long_action: true,
          last_step: current_step,
          last_action: current_action
      end

      def current_step
        short? ? route : route[0]
        # pin 0
        #return route return unless long?
        #route[0] # pin on start line
        #route.shuffle.first
        #route.at(customer_data["step"] || 0)
      end

      # fetch current_action (bot command)
      def current_action
        @current_action ||=
          processor&.available_cmd || \
          "/" + self.class.to_s.split("::")[-1][0..-7].underscore
      end

      def views
        @views ||= Bot::Views::Instance.new(chat_id, binding)
      end

      # delegate (.*)_message methods to api.send_message text: $1
      # delegate any missing_method to Views if .respond_to?
      #
      def method_missing(method_name, *arguments, &block)
        having = views.respond_to? method_name

        if method_name.to_s =~ /(.*)_message/ and not having
          views.response_message $1.capitalize
        elsif having
          views.send method_name, *arguments, &block
        else
          super
        end
      end

      private
        def chat_id; processor&.chat_id; end
    end
  end
end

