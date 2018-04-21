require "hamster/immutable"
require "hamster/set"

RSpec.describe Hamster::Set do
  it "includes Immutable" do
    expect(Hamster::Set).to include(Hamster::Immutable)
  end
end
