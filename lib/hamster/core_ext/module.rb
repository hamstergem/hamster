module Hamster

  module CoreExt

    module Module

      def sobriquet(as, name)
        method = instance_method(name)
        arity = method.arity.abs
        source_location = method.source_location

        args = ("a".."z").take(arity)
        args[-1] = "*#{args[-1]}" if method.arity < 0
        args = args.push("&block")
        args = args.join(",")

        definition = <<-EOE
          def #{as}(#{args})
            #{name}(#{args})
          end
        EOE

        class_eval(definition, source_location.first, source_location.last)
      end

    end

  end

end

class Module

  include Hamster::CoreExt::Module

end
