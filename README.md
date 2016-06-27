> Telegram Bot X | skeleton
---

##### install and run

            rbenv local 2.3.1
            bundle install
            cp config/settings.yml.default config/settings.yml

            rake # to run specs
            script/console # ripl

            # You should setup webHooks first
            #  https://core.telegram.org/bots/api#setwebhook
            #
            ruby http_bot_v2.rb # to start sinatra


##### modules:

* Sinatra `./http_bot_v2` - general point to communicate with webHooks
> every message which sent to TelegramBot, income to sinatra with POST request, see https://core.telegram.org/bots/api#getting-updates

> recieve `Update` JSON-serialized objects:

            {"update_id"=>607265587, "message"=>{"message_id"=>955, "from"=>{"id"=>62061342, "first_name"=>"Oleg", "last_name"=>"Artamonov", "username"=>"sletix"}, "chat"=>{"id"=>62061342, "first_name"=>"Oleg", "last_name"=>"Artamonov", "username"=>"sletix", "type"=>"private"}, "date"=>1466816281, "text"=>"/help", "entities"=>[{"type"=>"bot_command", "offset"=>0, "length"=>5}]}}

> https://core.telegram.org/bots/api#making-requests-when-getting-updates


* sinatra action create `Bot::UpdateRequest.new :json`

  * Inside `Bot::UpdateRequest` validate input request and call processor `Bot::Processor::%UpdateDateType%`.

  * `Bot::Processor::Message` - when income message-update
  * `Bot::Processor::CallBackQuery` - when income callback_query-update, after customer taped to special `callback_query_button`
  > https://core.telegram.org/bots/api#callbackquerya
  > https://core.telegram.org/bots#inline-keyboards-and-on-the-fly-updating

  * `Bot::Processor::EditedMessage` - when income update with edited message
  * ...

  * inside processor: parse coming commands(if exist) from message, choose special schema object on different commands(routes)
    * `Bot::ActionRoute::**Schema`
  > it's can be helpful when we making hard interactive use-cases

  * `Bot::ActionRoute` - have little routing mechanizm
    * `./config/routes.yml` - routes(bot commands) with yaml format:

              "/command": "action_view_method"
              "/command2": "action_schema_method"

              "/pizza":
                - "show_pizza_menu"
                - "check_order"
                - "get_payment"
                - "waiting_order_data"

  * `Bot::ActionRoute::DefaultSchema` -  default schema
  > Shemas - like a rails_controller

  * `Bot::Views` - to render views (returns Hash objects)
  * text/markdown/html templates in `/views`


  * `Bot::API` - light wrapper to use telegram_bot_api
  > docs -> https://core.telegram.org/bots/api#making-requests

              >>  Bot::API.exec "/sendMessage", chat_id: 62061342, text: "knock, knock"
              ...
              => {"ok"=>true, "result"=>{"message_id"=>1, "from"=>{"id"=>201081945, "first_name"=>"telegram-x", "username"=>"SchemaBot"}, "chat"=>{"id"=>62061342, "first_name"=>"Oleg", "last_name"=>"Artamonov", "username"=>"sletix", "type"=>"private"}, "date"=>1466824610, "text"=>"knock, knock"}}

              or
              >> Bot::API.exec method: "sendMessage", text: "*Whats up!*", chat_id: 62061342, parse_mode: "Markdown"
              ...

              >> Bot::API.exec "setWebhook", url: "https://server.com/callback_update"
              => {"ok"=>true, "result"=>true, "description"=>"Webhook was set"}

