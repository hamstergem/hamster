require "spec_helper"
require "hamster/vector"

describe Hamster::Vector do
  let(:vector) { Hamster.vector(*values) }

  describe "#set" do
    context "when empty" do
      let(:vector) { Hamster.vector }

      it "always raises an error" do
        (-1..1).each do |i|
          expect { vector.set(i) }.to raise_error
        end
      end
    end

    context "when not empty" do
      let(:vector) { Hamster.vector("A", "B", "C") }

      context "with a block" do
        context "and a positive index" do
          context "within the absolute bounds of the vector" do
            it "passes the current value to the block" do
              vector.set(1) { |value| value.should == "B" }
            end

            it "replaces the value with the result of the block" do
              result = vector.set(1) { |value| "FLIBBLE" }
              result.should == Hamster.vector("A", "FLIBBLE", "C")
            end

            it "supports to_proc methods" do
              result = vector.set(1, &:downcase)
              result.should == Hamster.vector("A", "b", "C")
            end
          end

          context "outside the absolute bounds of the vector" do
            it "raises an error" do
              expect { vector.set(vector.size) {} }.to raise_error
            end
          end
        end

        context "and a negative index" do
          context "within the absolute bounds of the vector" do
            it "passes the current value to the block" do
              vector.set(-2) { |value| value.should == "B" }
            end

            it "replaces the value with the result of the block" do
              result = vector.set(-2) { |value| "FLIBBLE" }
              result.should == Hamster.vector("A", "FLIBBLE", "C")
            end

            it "supports to_proc methods" do
              result = vector.set(-2, &:downcase)
              result.should == Hamster.vector("A", "b", "C")
            end
          end

          context "outside the absolute bounds of the vector" do
            it "raises an error" do
              expect { vector.set(-vector.size.next) {} }.to raise_error
            end
          end
        end
      end

      context "with a value" do
        context "and a positive index" do
          context "within the absolute bounds of the vector" do
            let(:set) { vector.set(1, "FLIBBLE") }

            it "preserves the original" do
              vector.should == Hamster.vector("A", "B", "C")
            end

            it "sets the new value at the specified index" do
              set.should == Hamster.vector("A", "FLIBBLE", "C")
            end
          end

          context "outside the absolute bounds of the vector" do
            it "raises an error" do
              expect { vector.set(vector.size, "FLIBBLE") }.to raise_error
            end
          end
        end

        context "with a negative index" do
          let(:set) { vector.set(-2, "FLIBBLE") }

          it "preserves the original" do
            set
            vector.should == Hamster.vector("A", "B", "C")
          end

          it "sets the new value at the specified index" do
            set.should == Hamster.vector("A", "FLIBBLE", "C")
          end
        end

        context "outside the absolute bounds of the vector" do
          it "raises an error" do
            expect { vector.set(-vector.size.next, "FLIBBLE") }.to raise_error
          end
        end
      end
    end

    context "from a subclass" do
      it "returns an instance of the subclass" do
        @subclass = Class.new(Hamster::Vector)
        @instance = @subclass[1,2,3]
        @instance.set(1, 2.5).class.should be(@subclass)
      end
    end

    context "on a large vector" do
      it "sets the new value at the specified index" do
        vector = Hamster.vector(*(1..2000).to_a).set(0, 100).set(1500, 200)
        vector[0].should be(100)
        vector[1500].should be(200)
        vector[1999].should be(2000)
      end
    end

    context "at indexes which are likely to exercise edge-case behavior" do
      it "still sets the new value at the specified index" do
        vector = Hamster.vector(*(1..33).to_a).set(31, 'a').set(32, 'b')
        vector[31].should == 'a'
        vector[32].should == 'b'
      end
    end
  end
end
