# frozen_string_literal: true

require 'hashes_equal/hash_diff_displayer'

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
  end
end
