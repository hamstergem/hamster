require "hamster/list"

module Hamster

  module CoreExt

    module IO

      def to_list(sep = $/)
        Stream.new do
          line = gets(sep)
          if line
            Sequence.new(line, to_list)
          else
            EmptyList
          end
        end
      end

    end

  end

end

class IO

  include Hamster::CoreExt::IO

end
