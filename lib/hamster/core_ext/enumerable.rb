require 'hamster/list'

module Hamster

  module CoreExt

    module Enumerable

      def to_list
        enum = each
        if line
          Stream.new(line) { to_list }
        else
          EmptyList
        end

      end

    end

  end

end

module Enumerable

  include Hamster::CoreExt::Enumerable

end
