module StateMachines
  module Integrations
    # Provides a set of base helpers for managing individual integrations
    module Base
      module ClassMethods
        # The default options to use for state machines using this integration
        attr_reader :defaults

        # The name of the integration
        def integration_name
          @integration_name ||= begin
            name = self.name.split('::').last
            name.gsub!(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
            name.gsub!(/([a-z\d])([A-Z])/, '\1_\2')
            name.downcase!
            name.to_sym
          end
        end

        # Whether this integration is available for the current library.  This
        # is only true if the ORM that the integration is for is currently
        # defined.
        def available?
          matching_ancestors.any? && Object.const_defined?(matching_ancestors[0].split('::')[0])
        end

        # The list of ancestor names that cause this integration to matched.
        def matching_ancestors
          []
        end

        # Whether the integration should be used for the given class.
        def matches?(klass)
          matches_ancestors?(klass.ancestors.map { |ancestor| ancestor.name })
        end

        # Whether the integration should be used for the given list of ancestors.
        def matches_ancestors?(ancestors)
          (ancestors & matching_ancestors).any?
        end

      end

      extend ClassMethods

      def self.included(base) #:nodoc:
        base.class_eval { extend ClassMethods }
      end
    end
  end
end
