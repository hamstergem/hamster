require 'hamster/list'

module Hamster

  module CoreExt

    module Enumerable

      def to_list
        Hamster.list(self)
      end

    end

  end

end

module Enumerable

  include Hamster::CoreExt::Enumerable

end
