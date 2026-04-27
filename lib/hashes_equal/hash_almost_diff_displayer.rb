# frozen_string_literal: true

require 'hashes_equal/hash_diff_displayer'

module HashesEqual
  class HashAlmostDiffDisplayer < HashDiffDisplayer
    class ToleranceMustBeNonNegativeNumeric < ArgumentError; end

    def initialize(expected:, actual:, tolerance:, strict: false)
      @tolerance = tolerance
      @strict = strict

      super(
        expected: expected,
        actual: actual,
        diff_options: {
          numeric_tolerance: tolerance,
          strict: strict
        }
      )
    end

    private

    attr_reader :tolerance, :strict

    def check_args
      super
      return if tolerance.is_a?(Numeric) && tolerance >= 0

      raise(
        ToleranceMustBeNonNegativeNumeric,
        "tolerance was #{tolerance.inspect}"
      )
    end
  end
end
