# frozen_string_literal: true

require 'hashes_equal/hash_diff_displayer'

module HashesEqual
  class HashRoundedDiffDisplayer < HashDiffDisplayer
    class PrecisionMustBeNonNegativeInteger < ArgumentError; end

    def initialize(expected:, actual:, precision:)
      @precision = precision

      super(expected: expected, actual: actual) do |_path, left, right|
        next unless left.is_a?(Numeric) && right.is_a?(Numeric)

        left.round(precision) == right.round(precision)
      end
    end

    private

    attr_reader :precision

    def check_args
      super
      return if precision.is_a?(Integer) && precision >= 0

      raise(
        PrecisionMustBeNonNegativeInteger,
        "precision was #{precision.inspect}"
      )
    end
  end
end
