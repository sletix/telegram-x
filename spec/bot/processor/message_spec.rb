require 'spec_helper'

describe Bot::Processor::Message do
  let :pmsg do
    Bot::Processor::Message.new FxU["message_data"]["message"]
  end
  let :w_pmsg do
    Bot::Processor::Message.new FxU["message_data_empty"]["message"]
  end

  describe "process message_data" do

    it "processor_message should responds_to :*" do
      pmsg.id.must_be :>, 10
      pmsg.created_at.must_be_instance_of DateTime
      pmsg.chat_type.must_equal 'private'
    end

    it "processor should not responds_to " do
      w_pmsg.text.must_be_nil
    end
  end
end
