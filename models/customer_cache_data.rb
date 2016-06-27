class CustomerCacheData < Struct.new :chat_id, :data
  extend Forwardable
  def_delegators :ostruct_data, :in_long_action, :last_action, :last_step

  class << self
    def find chat_id
      if data = $redis.get(key chat_id)
        new chat_id, JSON.parse(data)
      end
    end

    def store chat_id, data
      $redis.set(key(chat_id), data.to_json) == "OK"
    end

    def merge chat_id, new_data
      old_data = find(chat_id)&.data
      return false unless old_data
      store chat_id, old_data.merge(new_data)
    end

    def key chat_id
      "cached_chat_#{chat_id}"
    end
  end

  private
    def ostruct_data; OpenStruct.new data; end
end
