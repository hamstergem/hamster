require "hamster/immutable"
require "hamster/hash"

RSpec.describe Hamster::Hash do
  it "includes Immutable" do
    expect(Hamster::Hash).to include(Hamster::Immutable)
  end
end
