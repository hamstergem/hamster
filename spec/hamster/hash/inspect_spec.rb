require File.expand_path('../../../spec_helper', __FILE__)

require 'hamster/hash'

describe Hamster::Hash do

  describe "#inspect" do

    [
      [[], "{}"],
      [["A" => "aye"], "{\"A\" => \"aye\"}"],
      [[1 => :one, 2 => :two, 3 => :three], "{1 => :one, 2 => :two, 3 => :three}"]
    ].each do |values, expected|

      describe "on #{values.inspect}" do

        before do
          original = Hamster.hash(*values)
          @result = original.inspect
        end

        it "returns #{expected.inspect}" do
          @result.should == expected
        end

      end

    end

  end

end
