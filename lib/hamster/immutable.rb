require 'forwardable'

module Hamster

  module Immutable

    def self.included(klass)
      klass.extend(ClassMethods)
      klass.instance_eval do
        include InstanceMethods
      end
    end

    module ClassMethods

      def new(*args)
        super.freeze
      end

    end

    module InstanceMethods

      extend Forwardable

      def immutable?
        frozen?
      end

      alias_method :__copy__, :dup
      private :__copy__

      def dup
        self
      end
      def_delegator :self, :dup, :clone

      protected

      def transform_unless(condition, &block)
        condition ? self : transform(&block)
      end

      def transform(&block)
        __copy__.tap { |copy| copy.instance_eval(&block) }.freeze
      end

    end

  end

end
