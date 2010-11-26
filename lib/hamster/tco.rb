class Module

  def tco_eval(code)
    if defined?(RubyVM::InstructionSequence)
      RubyVM::InstructionSequence.compile_option = { tailcall_optimization: true, trace_instruction: false }
      RubyVM::InstructionSequence.new(<<-RUBY)
        #{self.class.name.downcase} #{name}
          #{code}
        end
      RUBY
    else
      self
    end.eval
  end

end
