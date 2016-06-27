require 'sinatra'
require './config/environment'

before do
  begin
    @data = JSON.parse request.body.read if request&.body
    $logger.info  "JSON: #{@data.inspect}"
  rescue JSON::ParserError => e
    $logger.warn e.message
    error 422
  end
end

# telegram bot webhook updates point
#
post '*' do
  content_type :json
  response = Bot::UpdateRequest.new(@data).response
  $logger.info "RESP: #{response.inspect}"
  response.to_json
end
