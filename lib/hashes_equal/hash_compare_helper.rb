# frozen_string_literal: true

require 'hashes_equal/hash_diff_displayer'
require 'hashes_equal/hash_almost_diff_displayer'
require 'hashes_equal/hash_rounded_diff_displayer'

module HashesEqual
  module HashCompareHelper
    def assert_hashes_equal(expected, actual, verbose: true)
      displayable_diff = HashDiffDisplayer.new(
        expected: expected,
        actual: actual
      ).call
      if verbose
        assert_equal expected, actual, displayable_diff
      else
        assert expected == actual, displayable_diff
      end
    end

    def assert_hashes_almost_equal(expected, actual, tolerance:, strict: false)
      displayer = HashAlmostDiffDisplayer.new(
        expected: expected,
        actual: actual,
        tolerance: tolerance,
        strict: strict
      )

      result = displayer.call

      assert displayer.diff.empty?, result
    end

    def assert_rounded_hashes_equal(expected, actual, precision:)
      displayer = HashRoundedDiffDisplayer.new(
        expected: expected,
        actual: actual,
        precision: precision
      )

      result = displayer.call

      assert displayer.diff.empty?, result
    end
  end
end
