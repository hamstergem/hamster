class Enumerable

  alias_method :reduce, :inject unless defined?(:reduce)

end
