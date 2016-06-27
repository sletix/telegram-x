require 'spec_helper'

describe Bot::UpdateRequest do

  describe '#new' do
    it 'should raise with wrong keys' do
      -> { Bot::UpdateRequest.new key: 'wrong' }
        .must_raise Bot::UpdateRequest::InvalidKeyError
    end

    it 'should raise with wrong data' do
      -> { Bot::UpdateRequest.new "message" => 'wrong' }
        .must_raise Bot::UpdateRequest::NotValidDataError
    end

    it 'should create process instance with correct data' do
      update = Bot::UpdateRequest.new Fixtures["updates"]["message_data"]
      update.processor.must_be_instance_of Bot::Processor::Message
      #update.response.must_equal "FOO"
    end
  end
end
