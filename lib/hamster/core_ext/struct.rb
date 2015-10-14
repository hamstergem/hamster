class Struct
  # Implement Struct#to_h for Ruby interpreters which don't have it
  # (such as MRI 1.9.3 and lower)
  unless method_defined?(:to_h)
    def to_h
      Hash[members.zip(values)]
    end
  end
end
