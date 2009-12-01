require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hamster::Hash do

  [:get, :[]].each do |method|

    describe "##{method}" do

      before do
        @hash = Hamster.hash("A" => "aye", "B" => "bee", "C" => "see", nil => "NIL")
      end

      [
        ["A", "aye"],
        ["B", "bee"],
        ["C", "see"],
        [nil, "NIL"]
        ].each do |key, value|

          it "returns the value (#{value.inspect}) for an existing key (#{key.inspect})" do
            @hash.send(method, key).should == value
          end

        end

        it "returns nil for a non-existing key" do
          @hash.send(method, "D").should be_nil
        end

      end

    end

  end
