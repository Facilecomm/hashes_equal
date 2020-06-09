# frozen_string_literal: true

require 'hashes_equal/enumerable_diff_displayer'

module HashesEqual
  module EnumerableCompareHelper
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
