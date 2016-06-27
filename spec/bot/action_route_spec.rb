require 'spec_helper'

describe Bot::ActionRoute do

  before do
    @route = Bot::ActionRoute
    @default = Bot::ActionRoute::DefaultSchema
  end

  describe "#get_schema_class" do

    it "should return true schemas" do
      @route.get_schema_class("/foo").must_be_nil
      @route.get_schema_class("/help").must_equal @default
      @route.get_schema_class("/pizza").wont_equal @default
    end

    it "check alias schema routing" do
      @route.get_schema_class("/pong").new.route.must_equal @route::Map["/ping"]
    end
  end

  describe "#is_alias?" do
    it "should return boolean when command is aliased in routes" do
      @route.is_alias?("/help").wont_be :==, true
      @route.is_alias?("/pong").must_be :==, true
    end
  end

  describe "#get_route" do
    it "should return some point from route" do
      @route.get_route("/pong").must_equal @route::Map["/ping"]
      @route.get_route("/wrong").must_be_nil
    end
  end

end
