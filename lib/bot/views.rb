module Bot

  # methods for generate "view"-objects for Telegram
  #
  module Views
    DirPath = "#{APP_ROOT}/views/%s"

    def response_message msg, chat_id=@chat_id
      { method: "sendMessage", chat_id: chat_id, text: msg }
    end

    def inline_btns_message msg, chat_id=@chat_id
      { method: "sendMessage",
        chat_id: chat_id,
        reply_markup: {
          inline_keyboard: [
            [{text:"-", callback_data:"negative"},
            {text:"+", callback_data: "positive"}]
          ]
        }, text: msg}
    end

    # with reply keyboard markup
    def request_contact msg="share your contact", chat_id=@chat_id
      { method: "sendMessage",
        chat_id: chat_id,
        reply_markup: {
          keyboard: [
            [{text: "Share contact", request_contact: true}]
          ],
          resize_keyboard: true,
          one_time_keyboard: true
        },
        text: msg }
    end

    def request_location chat_id=@chat_id
      request = request_contact(chat_id)
      request[:reply_markup][:keyboard] = [
        [{ text: "Share location", request_location: true }]
      ]
      request[:text ] = "And so, where are you? 🤖"
      request
    end

    def flash msg, callback_query_id
      { method: "answerCallbackQuery",
        callback_query_id: callback_query_id,
        text: "#{msg} 🦄" }
    end

    def test_md_message
      $logger.info "test_md_message rendering..."
      out = md_tpl_message 'test.md'
      $logger.info out
      out
    end

    def md_tpl_message tpl
      md_message text: render_tpl(tpl)
    end

    #def readme_md_message
      #md_tpl_message 'readme.md'
    #end

    def render_tpl name, cache=$global_template_cache || {}
      unless cache.has_key? name
        path = DirPath % [name+'.erb']
        raise "tpl not exist" unless File.exist? path
        cache[name] = File.read path
      end

      ERB.new(cache[name]).result(@binding)
    end

    extend self

    # for simple form objects
    module Simple

      def message params={}
        { method: "sendMessage", text: nil, chat_id: @chat_id }.merge(params)
      end

      def md_message params={}
        message({ parse_mode: 'Markdown' }.merge(params))
      end

      def html_message params={}
        message({ parse_mode: 'HTML' }.merge(params))
      end

      extend self
    end

    # wrapper for using instance var
    class Instance
      include Views
      include Simple

      def initialize chat_id, schema_binding=binding
        @chat_id, @binding = chat_id, schema_binding
      end
    end

  end


end
