require 'hamster/list'

module Hamster

  module CoreExt

    module Enumerator

      def to_list
        Stream.new do
          begin
            Sequence.new(self.next, to_list)
          rescue StopIteration
            EmptyList
          end
        end

      end

    end

  end

end

class Enumerator

  include Hamster::CoreExt::Enumerator

end
