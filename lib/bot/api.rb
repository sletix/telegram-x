module Bot

  # light wrapper to telegram api
  #  * see: https://core.telegram.org/bots/api#making-requests
  #
  class API
    include HTTParty
    base_uri "https://api.telegram.org/bot#{Settings["bot"]["token"]}"

    def self.send_message text, chat_id, params={}
      exec "/sendMessage", params.merge( chat_id: chat_id, text: text )
    end

    # method for send some messages to me
    def self.send_error e
      msg = "🆘  Error in processor #{e.class}: #{e.message}"
      Bot::API.exec Bot::Views.response_message(msg, 62061342)
      # send few messages to me
      #[ ,
        #views.md_tpl_message(:backtrace_error) ].each {|req| Bot::API.exec req  }
    rescue
      nil
    end

    # method can few cases for call:
    #
    #   # with string and hash:
    #   .exec "/methodName", { data: to_send }
    #
    #   # with hash only
    #   .exec { method: "methodName", data: to_send }
    #
    def self.exec method_name, params={}
      if Hash === method_name && params.empty?
        params = method_name.except :method, 'method'
        method_name = method_name[:method] || method_name['method']
      end

      path = (m = method_name.to_s).start_with?('/') ? m[1..-1] : m
      response = \
      post "/#{path}", body: params.to_json,
                              headers: { 'Content-Type' => 'application/json' }

      JSON.parse response.body
    end
  end
end
