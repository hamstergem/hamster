module Enumerable

  def reduce(memo = nil, &block)
    inject(memo, &block)
  end unless defined?(:reduce)

end
