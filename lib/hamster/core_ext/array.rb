class Array

  alias_method :reduce, :inject unless defined?(:reduce)

end
