# frozen_string_literal: true

require 'assertable'
require 'hashdiff'
require 'hashes_equal/generic_diff_displayer'

module HashesEqual
  class EnumerableDiffDisplayer < GenericDiffDisplayer
    class ExpectationMustBeEnumerable < ArgumentError; end
    class ActualValueMustBeEnumerable < ArgumentError; end

    private

    def check_args
      super
      raise ExpectationMustBeEnumerable unless expected.is_a?(Enumerable)
      raise ActualValueMustBeEnumerable unless actual.is_a?(Enumerable)
    end
  end
end
