# frozen_string_literal: true

require 'hashes_equal/enumerable_diff_displayer'
require 'hashes_equal/time_coarsener'

module HashesEqual
  module EnumerableCompareHelper
    def assert_time_aware_enumerable_equal(
      expected,
      actual,
      time_granularity:,
      verbose: true
    )
      time_coarsener = TimeCoarsener.new(time_granularity)
      time_coarsened_expected = time_coarsener.call(expected)
      time_coarsened_actual = time_coarsener.call(actual)

      assert_enumerable_equal(
        time_coarsened_expected,
        time_coarsened_actual,
        verbose: verbose
      )
    end

    def assert_enumerable_equal(expected, actual, verbose: true)
      displayable_diff = EnumerableDiffDisplayer.new(
        expected: expected,
        actual: actual
      ).call
      if verbose
        assert_equal expected, actual, displayable_diff
      else
        assert expected == actual, displayable_diff
      end
    end
  end
end
