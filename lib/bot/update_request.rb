module Bot

  # create instance after every recieved update-request from Telegram servers
  #
  class UpdateRequest
    extend Forwardable
    AllowKeys = %w(message callback_query edited_message)

    attr_reader :json, :processor
    def_delegator :@processor, :response

    def initialize data
      @json = data and ( die! if something_is_wrong? )
      @processor = processor_class.new(json[key]) and processor.safe_perform

      # cache current update
      #if chat_id = process&.chat&.id
        #CustomerCacheData.store chat_id, process.customer_data
      #end
    end

    def something_is_wrong?
      not key or not valid?
    end

    def die!
      raise InvalidKeyError, 'update keys is not allowed' unless key
      raise NotValidDataError, 'update data not valid' unless valid?
    end

    def valid?
      json.has_key?("update_id") and \
      case type
        when 'message', 'edited_message' then
          json[key].has_key? "message_id" and json[key].has_key? "date" and
          json[key].dig("chat","id") and json[key]["chat"]["type"]
        when 'callback_query' then
          json[key].has_key? "id" and json[key].has_key? "data"
          json[key].dig("from","id") and json[key]["from"]["first_name"]
        else true
      end
    end

    def key
      @key ||= @json&.keys&.detect{ |k| AllowKeys.include? k }
    end
    alias_method :type, :key


    def processor_class
      "Bot::Processor::#{type.classify}".safe_constantize
    end

    # init error class
    class InvalidKeyError < ArgumentError; end
    class NotValidDataError < ArgumentError; end
  end
end
